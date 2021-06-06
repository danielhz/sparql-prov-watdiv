#!/usr/bin/env ruby

require 'set'
require 'zlib'

dataset_full = "datasets/watdiv.100M-namedgraphs.nt.gz"
dataset_subset = "datasets/watdiv.100M-namedgraphs-subset.nt.gz"

sources = Set.new

File.open('datasets/sources.csv').each_line do |line|
  sources << line.strip
end

p sources.size

File.open(dataset_subset, 'w') do |out| 
  Zlib::GzipReader.open(dataset_full) do |gz|
    gz.each_line do |line|
      source = line.strip.sub(/\.$/, '').split(' ').last[1..-2]
      out.puts line.strip.gsub('~', '') if sources.include? source
    end
  end
end
