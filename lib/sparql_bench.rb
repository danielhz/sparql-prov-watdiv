require 'net/ssh'

class Endpoint
  def initialize(container)
    @container = container
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
    system "lxc start #{@container}"
  end

  def stop
    system "lxc stop #{@container}"
  end

  def run_query(file)
    system "curl --data-urlencode \"query=$(cat #{file})\" " +
           "-H \"Accept: text/csv\" #{endpoint_url}"
  end

  def bench_query(file)
  end
end

class LXDFusekiEndpoint < Endpoint
  def endpoint_url
    "http://#{container_ip}:3030/ds/sparql"
  end
  
  def start
    super
    system "lxc exec #{@container} -- su - ubuntu -c " +
           "'daemonize -E JVM_ARGS=${JVM_ARGS:--Xmx128G} " +
           "-c /home/ubuntu/apache-jena-fuseki-3.17.0 " +
           "-o stdout.log -e stderr.log " +
           "/home/ubuntu/apache-jena-fuseki-3.17.0/fuseki-server " +
           "--loc=/home/ubuntu/tdb /ds'"
  end
end

class LXDVirtuosoEndpoint < Endpoint
  def initialize(container)
    super(container)
    @user = 'debian'
  end
  
  def endpoint_url
    "http://#{container_ip}:8890/sparql/"
  end

  def start
    super
    
    puts "Starting service"
    virtuoso = 'virtuoso-7.2.5.1'
    system "lxc exec #{@container} -- su - #{@user} -c " +
           "'cd ~/#{virtuoso}/var/lib/virtuoso/db && " +
           "~/#{virtuoso}/bin/virtuoso-t'"

    loop do
      sleep 1
      output = `lxc exec #{@container} netstat | grep 1111`
      ready = output.split("\n").map do |line|
        line.split.last
      end.reduce(true) do |is_connected, status|
        is_connected = (is_connected and (status == 'ESTABLISHED'))
      end
      break if ready and output != ''
    end

    puts "Service started"
  end
end
