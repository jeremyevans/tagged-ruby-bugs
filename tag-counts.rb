#!/usr/local/bin/ruby

require 'csv'

BUG_FILE = "ruby-bugs.csv"
TAGS = Hash.new(0)

existing_rows = CSV.read(BUG_FILE, encoding: 'UTF-8').each do |_, tags, _|
  tags.split.each do |tag|
    TAGS[tag] += 1
  end
end

TAGS.sort_by{|_,v| -v}.each{|k,v| puts sprintf("%3i: %s", v, k)}
