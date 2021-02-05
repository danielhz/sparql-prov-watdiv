require 'csv'
require 'fileutils'

%w{B P T}.each do |mode|
  desc "Generate C3 queries for #{mode}"
  named_task "generate_c3_queries_#{mode}" do
    system "cp queries/watdiv_examples/C3-#{mode}.sparql queries/10M/C3/namedgraphs/#{mode}/00.sparql"
  end
end

%w{C3}.each do |query|
  tasks = %w{B P T}.map do |mode|
    task_dependency("generate_c3_queries_#{mode}")
  end
  
  task "generate_#{query}_queries" => tasks
end


QUERY_TEMPLATE_PARAMS_SCHEMES = [
  {template: 'C3'},
  {template: 'L3', attributes: {v3: 'Website2579'}},
  {template: 'S2', attributes: {v2: 'Country17'}},
  {template: 'S3', attributes: {v1: 'ProductCategory4'}},
  {template: 'S5', attributes: {v1: 'ProductCategory2'}},
  {template: 'S6', attributes: {v3: 'SubGenre135'}},
]

# Define tasks to generate the query params
QUERY_TEMPLATE_PARAMS_SCHEMES.filter{ |ps| ps.include? :attributes }.each do |params_scheme|
  template = params_scheme[:template]
  attributes = params_scheme[:attributes]

  # We have to define different params for each scale factor.
  %w{10M 100M}.each do |scale_factor|
    desc "Generate query params for template=#{template}, scale factor=#{scale_factor}"
    named_task "query_params_#{template}_#{scale_factor}" do
      endpoint = LXDFusekiEndpoint.new("watdiv-#{scale_factor}-namedgraphs-fuseki3-ubuntu2004")
      endpoint.start
      puts 'Running query'
      out = endpoint.run_query("queries/watdiv_params/#{template}.sparql")
      params = out.lines.drop(1).shuffle(random: Random.new(1))[0,10]
      params = params.map do |line|
        line.strip.sub('http://db.uwaterloo.ca/~galuc/wsdbm/', '')
      end
      File.open("params/#{template}_#{scale_factor}_params.csv", 'w') do |file|
        file.puts attributes.keys.sort.join(',')
        params.each { |line| file.puts line }
      end
      puts 'Params saved'
      puts 'Stoping endpoint and container'
      endpoint.stop
    end
  end
end

query_dependencies = []

QUERY_TEMPLATE_PARAMS_SCHEMES.each do |params_scheme|
  template = params_scheme[:template]
  attributes = params_scheme[:attributes] || {}

  %w{B P T}.each do |mode|
    %w{namedgraphs wikidata rdf}.each do |scheme|
      # Skip TripleProv queries for reification schemes unsupported by TripleProv
      next if mode == 'T' and scheme != 'namedgraphs'

      if attributes.empty?
        params = [{}]
      else
        params = CSV.parse(File.read("params/#{template}-10M-params.csv"), headers: true)
      end
      
      task_name = "generate_#{template}_10M_queries_#{scheme}_#{mode}"
      query_dependencies << task_dependency(task_name)
      template_file = "queries/watdiv_examples/#{scheme}/#{template}-#{mode}.sparql"
      desc "Generate #{template} 10M queries for #{scheme} #{mode}"
      named_task task_name, template_file do
        (0...params.size).each do |instance_id|
          query_file_path = "queries/10M/#{template}/#{scheme}/#{mode}/#{'%02d' % instance_id}.sparql"
          puts "Creating query #{query_file_path}"
          FileUtils.mkdir_p(File.dirname(query_file_path))
          File.open(query_file_path, 'w') do |query_instance_file|
            query_template = File.new(template_file).read
            attributes.each do |attribute, value|
              query_template.gsub!(value, params[instance_id][attribute.to_s])
            end
            query_instance_file.puts query_template
          end
        end
      end
    end
  end
end

desc 'Generate queries'
task :queries => query_dependencies
