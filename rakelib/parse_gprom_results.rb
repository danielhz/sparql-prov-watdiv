#!/usr/bin/env ruby

require 'csv'

def parse_line(line)
  row = line.split("\s")
  file_name = row[0].split('-')
  {
    query_name: file_name[5],
    repetition: file_name[6].split('.').first,
    time: row[4]
  }
end

%w{100M}.each do |size|
  # %w{sqlite sqliteram}.each do |engine|
  %w{sqliteram}.each do |engine|
    %w{C1 C2 C3 F1 F2 F3 F4 F5  L1 L2 L3 L4 L5 S1 S2 S3 S4 S5 S6 S7}.each do |template|
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

          results = "results/#{engine}-#{size}-#{template}-#{idx}-#{mode}.csv"
          puts "Creating #{results}"

          if Dir["answers/#{engine}-*#{template}-#{idx}-#{mode}-*-*.txt"].size > 0
            CSV.open(results, 'w') do |csv|
              csv << %w{engine size template scheme mode query_id repetition time status}
              
              `grep 'timer: TOTAL' answers/#{engine}-*#{template}-#{idx}-#{mode}-*-*.txt | less`.each_line do |line|
                result = parse_line(line)
                csv << [engine, size, template, idx, mode, result[:query_name], result[:repetition], result[:time], 200]
              end
            end
          end
        end
      end
    end
  end
end
