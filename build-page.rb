#!/usr/local/bin/ruby

require 'csv'
require 'thamble'

tags = Hash.new(0)
num_bugs = 0

rows = CSV.read("ruby-bugs.csv", encoding: 'UTF-8').each do |a|
  num_bugs += 1
  a[1].split.each do |tag|
    tags[tag] += 1
  end
end

title = "#{num_bugs} Tagged Open Ruby Bugs as of #{Time.at(Time.now, :in=>'+09:00')}"
table = Thamble.table(rows.reverse,
                      :tr=>proc{|row| {:class=>" #{row[1]} "}},
                      :caption=>title,
                      :headers=>'Bug ID,Tags,Subject') do |row, t| [
 t.a(row[0], "https://bugs.ruby-lang.org/issues/#{row[0]}"),
 row[1],
 t.a(t.raw(row[2]), "https://bugs.ruby-lang.org/issues/#{row[0]}") 
] end

File.binwrite('public/index.html', <<HTML)
<html>
<head>
<title>#{title}</title>
<link rel="stylesheet"  href="app.css" />
</head>
<body>
<p class="filter-buttons">Available Tags: #{tags.sort_by{|k,v| [-v, k]}.map{|k,_| "<input type=\"submit\" value=\"#{k}\" />"}.join("\n")}</p>
<label for="filter">Filter Tags:</label>
<input id="filter" type="text" size="80" />
(<span id="matched">#{num_bugs}</span> matched)
#{table}
<script src="app.js"></script>
</body>
</html>
HTML
