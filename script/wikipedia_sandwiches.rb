#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
require 'csv'

LIST_OF_SANDWICHES = "http://en.wikipedia.org/wiki/List_of_sandwiches"

doc = Nokogiri::HTML open(LIST_OF_SANDWICHES)

sandwiches = CSV.generate(headers: :first_row, write_headers: true) do |csv|
  csv << ["Name","Image","Origin","Description"]
  doc.css('table.wikitable').each do |table|
    table.css('tr').each do |row|
      cols = row.css('td').map do |cell| 
        cell.css('.reference').remove if !cell.css('.reference').empty?
        cell.content.empty? ? nil : cell.content.strip
      end
      if !cols.empty?
        cols.fill(cols.length, 4 - cols.length) { nil } if cols.length < 4
        csv << cols
      end
    end
  end
end

puts sandwiches
