
%w{10 100 1000}.each do |size|
  desc "Reify WatDiv #{size}M dataset"
  named_task("reify_dataset_#{size}M",
             task_dependency("get_dataset_#{size}M")) do
    FileUtils.chdir 'datasets' do
      %w(namedgraphs rdf wikidata).each do |scheme|
        system <<~SH
          pigz -d -c watdiv.#{size}M.nt.gz | \
          ../scripts/reify.rb #{scheme} | \
          pigz -9 -c > watdiv.#{size}M-#{scheme}.nt.gz
        SH
      end
    end
  end
end
