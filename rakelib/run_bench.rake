bench_dependencies = []

#%w{fuseki virtuoso virtuosoram}.each do |engine|
%w{virtuosoram}.each do |engine|
  %w{100M}.each do |size|
    %w{C1 C2 C3 F1 F2 F3 F4 F5 L1 L2 L4 L5 S1 S2 S3 S4 S5 S6 S7}.each do |template|
      # %w{namedgraphs rdf wikidata}.each do |scheme|
      %w{namedgraphs}.each do |scheme|
        #%w{B R P}.each do |mode|
        %w{P}.each do |mode|
          task_name = "run_bench_#{engine}_#{size}_#{template}_#{scheme}_#{mode}"
          desc "Run bench for #{engine} #{size} #{template} #{scheme} #{mode}"
          named_task task_name do
            case engine
            when 'fuseki'
              endpoint = LXDFusekiEndpoint.new("watdiv-#{size}-#{scheme}-fuseki3-ubuntu2004")
            when 'virtuoso'
              endpoint = LXDVirtuosoEndpoint.new("watdiv-#{size}-#{scheme}-virtuoso7-debian9")
            when 'virtuosoram'
              endpoint = LXDVirtuosoRAMEndpoint.new("watdiv-#{size}-#{scheme}-virtuoso7-debian9")
            end
            watdiv_bench(endpoint, size, template, scheme, mode)
          end

          bench_dependencies.append(task_dependency(task_name))
        end
      end
    end
  end
end

# %w{10M}.each do |size|
#   %w{C3 L3 S2 S3 S5 S6}.each do |template|
#     engine = 'tripleprov'
#     scheme = 'namedgraphs'
#     mode = 'T'

#     task_name = "run_bench_#{engine}_#{size}_#{template}_#{scheme}_#{mode}"
#     desc "Run bench for #{engine} #{size} #{template} #{scheme} #{mode}"
#     named_task task_name do
#       tripleprov_bench(size, template)
#     end

#     bench_dependencies.append(task_dependency(task_name))
#   end
# end

desc 'Run bench'
task :bench => bench_dependencies
