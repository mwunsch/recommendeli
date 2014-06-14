#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
require 'csv'

LIST_OF_SANDWICHES = "http://en.wikipedia.org/wiki/List_of_sandwiches"

doc = Nokogiri::HTML open(LIST_OF_SANDWICHES)

sandwiches = CSV.generate do |csv|
  doc.css('table.wikitable').each do |table|
    csv << ["Name","Image","Origin","Description"]
    table.css('tr').each do |row|
      cols = row.css('td').map do |cell| 
        cell.css('.reference').remove if !cell.css('.reference').empty?
        cell.content.empty? ? nil : cell.content
      end
      csv << cols unless cols.empty?
    end
  end
end

puts sandwiches
