#!/usr/bin/env ruby

require 'csv'

sources_file = 'data_sources/sources.csv'

File.open(sources_file, 'w') do |sources|
  File.open('data_sources/answer-src.csv').each_line do |line|
    row = CSV.parse_line(line).filter do |item|
      /^http:\/\/example.org\/statement\// === item
    end
    sources.puts row
  end
end

system "sort #{sources_file} | uniq -u > #{sources_file}_sorted"
system "mv #{sources_file}_sorted #{sources_file}"
