require 'csv'
require 'fileutils'

%w{B P T}.each do |mode|
  desc "Generate C3 queries for #{mode}"
  named_task "generate_c3_queries_#{mode}" do
    system "cp queries/watdiv_examples/C3-#{mode}.sparql queries/10M/C3/namedgraphs/#{mode}/00.sparql"
  end
end

QUERY_TEMPLATE_PARAMS_SCHEMES = [
  {template: 'L3', attributes: {v3: 'Website2579'}},
  {template: 'S2', attributes: {v2: 'Country17'}},
]

QUERY_TEMPLATE_PARAMS_SCHEMES.each do |params_scheme|
  template = params_scheme[:template]
  attributes = params_scheme[:attributes]
  
  desc "Generate #{template} queries params"
  named_task "generate_#{template}_queries_params" do
    endpoint = LXDFusekiEndpoint.new('watdiv-10M-namedgraphs-fuseki3-ubuntu2004')
    endpoint.start
    out = endpoint.run_query("queries/watdiv_params/#{template}.sparql")
    params = out.lines.drop(1).shuffle(random: Random.new(1))[0,10]
    params = params.map do |line|
      line.strip.sub('http://db.uwaterloo.ca/~galuc/wsdbm/', '')
    end
    File.open("params/#{template}-10M-params.csv", 'w') do |file|
      file.puts attributes.keys.sort.join(',')
      params.each { |line| file.puts line }
    end
    endpoint.stop
  end
end

QUERY_TEMPLATE_PARAMS_SCHEMES.each do |params_scheme|
  template = params_scheme[:template]
  attributes = params_scheme[:attributes]

  %w{B P T}.each do |mode|  
    desc "Generate #{template} 10M queries for #{mode}"
    named_task "generate_#{template}_10M_queries_#{mode}" do
      params = CSV.parse(File.read("params/#{template}-10M-params.csv"), headers: true)
      (0...10).each do |instance_id|
        query_file_path = "queries/10M/#{template}/namedgraphs/#{mode}/#{'%02d' % instance_id}.sparql"
        FileUtils.mkdir_p(File.dirname(query_file_path))
        File.open(query_file_path, 'w') do |query_instance_file|
          query_template = File.new("queries/watdiv_examples/#{template}-#{mode}.sparql").read
          attributes.each do |attribute, value|
            query_template.gsub!(value, params[instance_id][attribute.to_s])
          end
          query_instance_file.puts query_template
        end
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

#   -rw-rw-r-- 1 ubuntu ubuntu  264 Jan 24 09:38 S3-B.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  962 Jan 24 09:38 S3-P.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  216 Jan 24 09:38 S3-T.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  304 Jan 24 09:38 S5-B.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  944 Jan 24 09:38 S5-P.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  249 Jan 24 09:38 S5-T.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  258 Jan 24 09:38 S6-B.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  844 Jan 24 09:38 S6-P.sparql
#   -rw-rw-r-- 1 ubuntu ubuntu  186 Jan 24 09:38 S6-T.sparql
