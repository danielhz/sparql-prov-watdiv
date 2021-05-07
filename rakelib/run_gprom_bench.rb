#!/usr/bin/env ruby

Dir['queries/100M/*/SQL/00.sql'].sort.reject do |query_file|
  /C1/ === query_file or /C2/ === query_file or /C3/ === query_file or /F4/ === query_file
end.each do |query_file|
  puts "Running #{query_file}"
  query_name = query_file.sub('queries/', '').gsub('/', '-')
  answers_name = "sqlite-psog-#{query_name.sub(/.sql$/, '.txt')}"
  
  system "lxc file push #{query_file} gprom/home/ubuntu/#{query_name}"
  system "lxc exec gprom -- su - ubuntu -c 'gprom -queryFile #{query_name} " +
         "-backend sqlite -db watdiv-100M-psog.db -timing > answers/#{answers_name}'"
  system "lxc file pull gprom/home/ubuntu/answers/#{answers_name} answers/#{answers_name}"
end
