
desc 'Reify WatDiv 10M dataset'
named_task 'reify_dataset_10M', task_dependency('get_dataset_10M') do
  FileUtils.chdir 'datasets' do
    %w(namedgraphs rdf wikidata).each do |scheme|
      system <<~SH
        pigz -d -c watdiv.10M.nt.gz | \
        ../scripts/reify.rb #{scheme} | \
        pigz -9 -c > watdiv.10M-#{scheme}.nt.gz
      SH
    end
  end
end
task_dependency 'get_dataset_10M'
