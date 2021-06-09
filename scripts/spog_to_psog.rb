#!/usr/bin/env ruby

require 'csv'

while str = STDIN.gets
  quad = CSV.parse_line(str)
  puts CSV.generate_line([quad[1], quad[0], quad[2], quad[3]])
end
