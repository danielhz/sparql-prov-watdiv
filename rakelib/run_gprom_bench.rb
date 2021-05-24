#!/usr/bin/env ruby

ENGINE = 'sqlite'

%w{sqlite}.each do |engine|
  %w{vp 6idx pso spo}.each do |idx|
    # %w{C1 C2 C3 F1 F2 F3 F4 F5 L1 L2 L3 L4 L5 S1 S2 S3 S4 S5 S6 S7}.each do |template|
    %w{C2 F3 C3 F4}.each do |template|
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
        
        (1..5).each do |iteration|

          Dir["queries/100M/#{template}/#{schema}/#{mode}/*.sql"].to_a.sort.each do |query_file|
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
end



