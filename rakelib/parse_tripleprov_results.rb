#!/usr/bin/env ruby

require 'csv'

files = %w{02 04 05 06}.map do |file_id|
  "tripleprov/runtime-#{file_id}.txt"
end

CSV.open('results/tripleprov-hardcoded.csv', 'w') do |csv|
  csv << %w{engine size template scheme mode query_id repetition time status}
  files.each do |file_name|
    File.new(file_name).each_line do |line|
      row = line.split
      csv << ['tripleprov', '100M', row[4].upcase.sub(':', ''),
         'namedgraphs', 'T', '00', row[2].to_i + 1, row[5], 200]
    end
  end

  %W{S4 F1}.each do |timeout_query|
    csv << ['tripleprov', '100M', timeout_query,
            'namedgraphs', 'T', '00', 1, 300, 100]
  end
end
