
desc 'Reify WatDiv 10M dataset'
named_task 'reify_dataset_10M', task_dependency('get_dataset_10M') do
  FileUtils.chdir 'datasets' do
    system <<~SH
      pigz -d -c watdiv.10M.nt.gz | \
      ../scripts/reify.rb namedgraphs | \
      pigz -9 -c > watdiv.10M-rdf.nt.gz"
    SH

    system <<~SH
      pigz -d -c watdiv.10M.nt.gz | \
      ../scripts/reify.rb rdf | \
      pigz -9 -c > watdiv.10M-rdf.nt.gz"
    SH

    system <<~SH
      pigz -d -c watdiv.10M.nt.gz | \
      ../scripts/reify.rb wikidata | \
      pigz -9 -c > watdiv.10M-rdf.nt.gz"
    SH
  end
end
task_dependency 'get_dataset_10M'
