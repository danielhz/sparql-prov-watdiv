
%w{10 100 1000}.each do |size|
  desc "Get WatDiv #{size}M dataset"
  named_task "get_dataset_#{size}M" do
    FileUtils.chdir 'datasets' do
      system <<~SH
      curl https://dsg.uwaterloo.ca/watdiv/watdiv.#{size}M.tar.bz2 \
           --output watdiv.#{size}M.tar.bz2
    SH
      system "tar -xjf watdiv.#{size}M.tar.bz2"
      system "rm saved.txt"
      system "rm watdiv.#{size}M.tar.bz2"
      system "pigz -9 watdiv.#{size}M.nt"
    end
  end
end
