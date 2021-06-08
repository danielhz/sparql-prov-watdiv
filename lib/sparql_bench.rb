require 'net/ssh'
require 'csv'
require 'benchmark'
require 'erb'
require 'net/http'
require 'typhoeus'

include ERB::Util

class Endpoint
  def initialize(container, timeout = 3000)
    @container = container
    @timeout = timeout
  end

  def container_ip
    loop do
      sleep 1
      ip = `lxc list --columns n4 --format csv | grep #{@container},`.
             gsub('(eth0)', '').gsub("#{@container},", '').strip
      return ip unless ip == ''
    end
  end

  def start
    container_start
    service_start
  end

  def container_start
    puts "Starting container #{@container}"
    system "lxc start #{@container}"
    puts 'Container started'
  end

  def stop
    system "lxc stop #{@container}"
  end

  def run_query(file)
    cmd = "curl -s -m #{@timeout} " +
          "--data-urlencode \"query=$(cat #{file})\" " +
          "-H \"Accept: text/csv\" #{endpoint_url}"
     `#{cmd}`
  end

  def http_connection
    if @http.nil?
      @http = Net::HTTP.new(URI.parse(endpoint_url).host, URI.parse(endpoint_url).port)
      @http.open_timeout = 60
      @http.read_timeout = @timeout.to_i
    end
    @http
  end

  def encoded_query_from_file(file)
    query = ''
    File.new(file).each_line do |line|
      query << line unless /^#/ === line
    end
    url_encode(query)
  end

  def typhoeus_bench_query(file)
    url = "#{endpoint_url}?query=#{encoded_query_from_file(file)}"
    resp = nil
    time = Benchmark.measure do
      resp = Typhoeus.get(url)
    end
    [time.real, resp.code]
  end

  def nethttp_bench_query(file)
    url = "#{endpoint_url}?query=#{encoded_query_from_file(file)}"
    result = []
    begin
      resp = nil
      time = Benchmark.measure do
        resp = http_connection.get(URI(url), {'Accept'=>'text/csv'})
      end
      result = [time.real, resp.code, resp.body]
    rescue RuntimeError => e
      result = [300, 100]
    end
    #puts resp.body
    result
  end

  def bench_query(file)
    sleep 0.5
    cmd = "curl -s -o /dev/null -w \"%{time_total}:%{http_code}\" -m #{@timeout} " +
          "--data-urlencode \"query=$(cat #{file})\" " +
          "-H \"Accept: text/csv\" #{endpoint_url}"
    `#{cmd}`.split(':')
  end
end

class LXDFusekiEndpoint < Endpoint
  def initialize(container, timeout = 300)
    super(container, timeout)
    @user = 'ubuntu'
  end

  def name
    'fuseki'
  end
    
  def endpoint_url
    "http://#{container_ip}:3030/ds/sparql"
  end
  
  def service_start
    puts "Starting service"
    system "lxc exec #{@container} -- su - ubuntu -c " +
           "'daemonize -E JVM_ARGS=${JVM_ARGS:--Xmx128G} " +
           "-c /home/ubuntu/apache-jena-fuseki-3.17.0 " +
           "-o stdout.log -e stderr.log " +
           "/home/ubuntu/apache-jena-fuseki-3.17.0/fuseki-server " +
           "--conf=/home/ubuntu/fuseki-config.ttl'"
    
    loop do
      sleep 1
      output = `lxc exec #{@container} -- netstat -tl | grep ':3030 '`
      break if output != ''
    end
    puts "Service started"
  end
end

class LXDVirtuosoEndpoint < Endpoint
  def initialize(container, timeout = 300)
    super(container, timeout)
    @user = 'debian'
  end

  def name
    'virtuoso'
  end
  
  def endpoint_url
    "http://#{container_ip}:8890/sparql/"
  end

  def service_start
    puts "Starting service"
    virtuoso = 'virtuoso-7.2.5.1'
    system "lxc exec #{@container} -- su - #{@user} -c " +
           "'cd ~/#{virtuoso}/var/lib/virtuoso/db && " +
           "~/#{virtuoso}/bin/virtuoso-t'"

    loop do
      sleep 1
      output = `lxc exec #{@container} -- netstat -tl | grep ':8890 '`
      break if output != ''
    end
    puts "Service started"
  end
end

class LXDVirtuosoRAMEndpoint < Endpoint
  def initialize(container, timeout = 300)
    super(container, timeout)
    @user = 'debian'
  end

  def name
    'virtuoso-ram'
  end
  
  def endpoint_url
    "http://#{container_ip}:8890/sparql/"
  end

  def service_start
    puts "Creating RAM disk"
    @virtuoso = '/home/debian/virtuoso-7.2.5.1_disk'
    @virtuoso_ram = '/home/debian/virtuoso-7.2.5.1'
    @virtuoso_ram_db = "#{@virtuoso_ram}/var/lib/virtuoso/db"
    system "lxc exec #{@container} -- mkdir -p #{@virtuoso_ram}"
    system "lxc exec #{@container} -- chown debian:debian #{@virtuoso_ram}"
    system "lxc exec #{@container} -- mount -t tmpfs -o size=80g virtuoso_ram_disk #{@virtuoso_ram}"
    system "lxc exec #{@container} -- chown debian:debian #{@virtuoso_ram}"
    puts "Copying files to the RAM disk"
    time_0 = Time.now
    system "lxc exec #{@container} -- su - #{@user} -c " +
           "'cp -r #{@virtuoso}/* #{@virtuoso_ram}/'"
    puts "Copying data to the RAM disks lasted #{Time.now - time_0} seconds"
    puts "Starting service"
    system "lxc exec #{@container} -- su - #{@user} -c " +
           "'cd #{@virtuoso_ram_db} && #{@virtuoso_ram}/bin/virtuoso-t'"

    loop do
      sleep 1
      output = `lxc exec #{@container} -- netstat -tl | grep ':8890 '`
      break if output != ''
    end
    puts "Service started"
  end

  def stop
    puts 'Stoping service'
    system "lxc exec #{@container} -- su - #{@user} -c " +
           "\"#{@virtuoso_ram}/bin/isql 'EXEC=shutdown()'\""
    sleep 5
    system "lxc exec #{@container} -- umount #{@virtuoso_ram}"
    super
  end
end

class LXDVirtuosoRAMTyphoEndpoint < LXDVirtuosoRAMEndpoint
  def name
    'virtuoso-typ'
  end
end

class LXDVirtuosoRAMCurlEndpoint < LXDVirtuosoRAMEndpoint
  def name
    'virtuoso-curl'
  end
end

def watdiv_bench(endpoint, size, template, scheme, mode, times = 5)
  puts "Starting workload #{[endpoint, size, template, scheme, mode].join('-')}"
  
  endpoint.start
  queries = Dir[File.join('queries', size, template, scheme, mode, '*.sparql')].sort

  queries.each do |query|
    puts "warming up #{query}"
    FileUtils.mkdir_p('answers')
    answers = query.gsub('/', '-').sub('.sparql', '.csv').sub('queries-', "answers/#{endpoint.name}-")
    File.open(answers, 'w') do |file|
      file.write endpoint.run_query(query)
    end
  end

  results = "results/#{endpoint.name.sub('-', '')}-#{size}-#{template}-#{scheme}-#{mode}.csv"
  CSV.open(results, 'w') do |csv|
    csv << %w{engine size template scheme mode query_id repetition time status}
    (1..times).each do |repetition|
      queries.each do |query|
        puts "running query #{query} (repetition #{repetition})"
        out = endpoint.bench_query(query)
        query_name = File.basename(query).sub(/.sparql$/, '')
        csv << [endpoint.name, size, template, scheme, mode, query_name, repetition, out[0], out[1]]
      end
    end
  end
  
  endpoint.stop
end

class TripleProvEndpoint
  def initialize
    @home = '/home/ubuntu/sparql-prov-watdiv/tripleprov_demo/release'
  end

  def name
    'tripleprov'
  end

  def bench_query(file)
    output = `cd #{@home} && ./tripleprov #{file}`
    {body: output, time: output.lines.last.split.last}
  end
end

def tripleprov_bench(size, template, times = 5)
  endpoint = TripleProvEndpoint.new
  scheme = 'namedgraphs'
  mode = 'T'
  
  puts "Starting workload #{[endpoint.name, size, template, scheme, mode].join('-')}"

  # tp.bench_query('/home/ubuntu/sparql-prov-watdiv/queries/10M/S2/namedgraphs/T/00.sparql')

  queries = Dir[File.join('queries', size, template, scheme, mode, '*.sparql')].sort

  results = "results/#{endpoint.name}-#{size}-#{template}-#{scheme}-#{mode}.csv"
  CSV.open(results, 'w') do |csv|
    csv << %w{engine size template scheme mode query_id repetition time status}
    queries.each do |query|
      (1..times).each do |repetition|
        puts "Running query #{query} (repetition #{repetition})"
        result = endpoint.bench_query(File.absolute_path query)
        
        answers = query.gsub('/', '-').sub('.sparql', '.csv').sub('queries-', "answers/#{endpoint.name}-")
        File.open(answers, 'w') do |file|        
          file.puts result[:body]
        end

        query_name = File.basename(query).sub(/.sparql$/, '')
        csv << [endpoint.name, size, template, scheme, mode, query_name, repetition, result[:time], 200]
      end
    end
  end
end
