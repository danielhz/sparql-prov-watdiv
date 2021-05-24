#!/usr/bin/env ruby

ENGINE = 'sqlite'

%w{sqlite}.each do |engine|
  %w{spo pso 6idx vp}.each do |idx|
    %w{B P}.each do |mode|
      schema = case idx
               when 'spo'
                 'quads'
               when 'pso'
                 'quads'
               when '6idx'
                 'quads'
               when 'vp'
                 'vp'
               else
                 raise "Unsuported idx #{idx}"
               end
      puts "queries/100M/*/#{schema}/#{mode}/00.sql"
      puts idx

      (1..5).each do |iteration|

        Dir["queries/100M/*/#{schema}/#{mode}/*.sql"].sort.reject do |query_file|
          /C1/ === query_file or
            /C2/ === query_file or
            #   /F1/ === query_file or /F2/ === query_file or
            /F3/ === query_file or
            # /F5/ === query_file or
            #   /L1/ === query_file or /L2/ === query_file or /L3/ === query_file or /L4/ === query_file or /L5/ === query_file or
            #   /S1/ === query_file or /S2/ === query_file or /S3/ === query_file or
            /S4/ === query_file or
            /C3/ === query_file or
            /F4/ === query_file
        end.each do |query_file|
          puts "Running #{query_file} on ENGINE=#{ENGINE} IDX=#{idx} ITERATION=#{iteration}"
          query_name = query_file.sub('queries/', '').gsub('/', '-')
          answers_name = "sqlite-#{query_name.sub(/.sql$/, '.txt')}".
                           sub('quads', idx).sub(/.txt$/, "-#{iteration}.txt")
          # puts "Answers name: #{answers_name}"
          # puts "Query name: #{query_name}"
          
          system "lxc file push #{query_file} gprom/home/ubuntu/queries/#{query_name}"
          system "lxc exec gprom -- su - ubuntu -c 'gprom -queryFile queries/#{query_name} " +
                 "-backend sqlite -db watdiv-100M-#{idx}.db -timing > answers/#{answers_name}'"
          system "lxc file pull gprom/home/ubuntu/answers/#{answers_name} answers/#{answers_name}"
        end      
      end

    end
  end
end



