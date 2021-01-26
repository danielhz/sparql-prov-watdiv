require 'csv'

%w{B P T}.each do |mode|
  desc "Generate C3 queries for #{mode}"
  named_task "generate_c3_queries_#{mode}" do
    system "cp queries/watdiv_examples/C3-#{mode}.sparql queries/10M/C3/namedgraphs/#{mode}/00.sparql"
  end
end

desc "Generate L3 queries params"
named_task "generate_l3_queries_params" do
  endpoint = LXDFusekiEndpoint.new('watdiv-10M-namedgraphs-fuseki3-ubuntu2004')
  endpoint.start
  out = endpoint.run_query('queries/watdiv_params/L3.sparql')
  params = out.lines.drop(1).shuffle(random: Random.new(1))[0,10]
  params = params.map do |line|
    line.strip.sub('http://db.uwaterloo.ca/~galuc/wsdbm/', '')
  end
  File.open('params/L3-10M-params.csv', 'w') do |file|
    file.puts 'v3'
    params.each { |line| file.puts line }
  end
  endpoint.stop
end

%w{B P T}.each do |mode|  
  desc "Generate L3 10M queries for #{mode}"
  named_task "generate_l3_10M_queries_#{mode}" do
    params = CSV.parse(File.read('params/L3-10M-params.csv'), headers: true)
    (0...10).each do |instance_id|
      File.open("queries/10M/L3/namedgraphs/#{mode}/#{'%02d' % instance_id}.sparql", 'w') do |query_instance_file|
        query_instance_file.puts File.new("queries/watdiv_examples/L3-#{mode}.sparql").
                                   read.gsub('Website2579', params[instance_id]['v3'])
      end
    end
  end
end

%w{C3}.each do |query|
  tasks = %w{B P T}.map do |mode|
    task_dependency("generate_c3_queries_#{mode}")
  end
  
  task "generate_#{query}_queries" => tasks
end


#   -rw-rw-r-- 1 ubuntu ubuntu  128 Jan 24 09:38 L3-B.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  621 Jan 24 09:38 L3-P.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  116 Jan 24 09:38 L3-T.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  328 Jan 24 09:38 S2-B.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu 1024 Jan 24 09:38 S2-P.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  240 Jan 24 09:38 S2-T.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  264 Jan 24 09:38 S3-B.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  962 Jan 24 09:38 S3-P.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  216 Jan 24 09:38 S3-T.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  304 Jan 24 09:38 S5-B.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  944 Jan 24 09:38 S5-P.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  249 Jan 24 09:38 S5-T.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  258 Jan 24 09:38 S6-B.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  844 Jan 24 09:38 S6-P.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  186 Jan 24 09:38 S6-T.sparql
