#!/usr/local/bin/ruby

require 'csv'
require 'net/http'

BUG_FILE = "ruby-bugs.csv"

Bug = Struct.new(:id, :tags, :subject)
class Bug
  MAP = {}

  attr_accessor :active

  def self.create(id, tags, subject)
    bug = new(id, tags, subject)
    MAP[bug.id] = bug
    bug
  end

  def self.csv
    CSV.generate do |csv|
      MAP.sort_by{|k,_| k.to_i}.each do |_, bug|
        if bug.active
          csv << bug.to_a
        else
          puts "Resolved Ruby Bug: #{bug.id}"
        end
      end
    end
  end
end

existing_rows = CSV.read(BUG_FILE, encoding: 'UTF-8').map{|x| Bug.create(*x)}

body = Net::HTTP.get(URI('https://bugs.ruby-lang.org/projects/ruby-trunk/issues?c%5B%5D=tracker&c%5B%5D=status&c%5B%5D=subject&c%5B%5D=assigned_to&c%5B%5D=updated_on&f%5B%5D=status_id&f%5B%5D=tracker_id&f%5B%5D=&group_by=&op%5Bstatus_id%5D=o&op%5Btracker_id%5D=%3D&per_page=500&set_filter=1&sort=id%3Adesc&utf8=.&v%5Btracker_id%5D%5B%5D=1'))

body.scan(%r{<td class="subject"><a href="/issues/(\d+)">([^<]+)</a></td>}).each do |id, subject|
  if bug = Bug::MAP[id]
    bug.subject = subject
    bug.active = true
  else
    puts "New Ruby Bug: #{id}"
    bug = Bug.create(id, '', subject)
    bug.active = true
  end
end

csv = Bug.csv
File.rename(BUG_FILE, "old/ruby-bugs-#{Time.now.to_i}.csv")
File.binwrite(BUG_FILE, csv)
