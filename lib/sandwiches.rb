$LOAD_PATH.unshift File.dirname(__FILE__)

require 'sandwich'
require 'csv'
require 'set'
require 'pp'

class Sandwiches
  DATA_DIR = File.join File.expand_path("..",File.dirname(__FILE__)), "data"
  BREAD_PATH = File.join DATA_DIR, "breads.csv"
  CHEESE_PATH = File.join DATA_DIR, "cheeses.csv"
  MEAT_PATH = File.join DATA_DIR, "sandwichmeats.csv"
  SAUCE_PATH = File.join DATA_DIR, "sauces.csv"
  VEGGIE_PATH = File.join DATA_DIR, "veggies.csv"

  def self.rows
    Hash[[BREAD_PATH, CHEESE_PATH, MEAT_PATH, SAUCE_PATH, VEGGIE_PATH].map {|csv| 
      [File.basename(csv, ".csv").to_sym, import(csv)] 
    }]
  end

  def self.import(csv_path)
    CSV.foreach(csv_path, headers: true, header_converters: [:downcase, :symbol])
  end

end
