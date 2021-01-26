bench_dependencies = []

%w{fuseki virtuoso}.each do |engine|
  %w{10M}.each do |size|
    %w{C3 L3 S2 S3 S5 S6}.each do |template|
      %w{namedgraphs}.each do |scheme|
        %w{B P}.each do |mode|
          task_name = "run_bench_#{engine}_#{size}_#{template}_#{scheme}_#{mode}"
          desc "Run bench for #{engine} #{size} #{template} #{scheme} #{mode}"
          named_task task_name do
            case engine
            when 'fuseki'
              endpoint = LXDFusekiEndpoint.new("watdiv-#{size}-#{scheme}-fuseki3-ubuntu2004")
            when 'virtuoso'
              endpoint = LXDVirtuosoEndpoint.new("watdiv-#{size}-#{scheme}-virtuoso7-debian9")
            end
            watdiv_bench(endpoint, size, template, scheme, mode)
          end

          bench_dependencies.append(task_dependency(task_name))
        end
      end
    end
  end
end

desc 'Run bench'
task :bench => bench_dependencies
