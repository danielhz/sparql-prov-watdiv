
desc 'Get WatDiv 10M dataset'
named_task 'get_dataset_10M' do
  FileUtils.chdir 'datasets' do
    system <<~SH
      curl https://dsg.uwaterloo.ca/watdiv/watdiv.10M.tar.bz2 \
           --output watdiv.10M.tar.bz2
    SH
    system "tar -xjf watdiv.10M.tar.bz2"
    system "rm saved.txt"
    system "rm watdiv.10M.tar.bz2"
    system "pigz -9 watdiv.10M.nt"
  end
end
task_dependency 'get_dataset_10M'
