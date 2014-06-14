$LOAD_PATH.unshift File.dirname(__FILE__)

require 'sandwich'
require 'csv'
require 'set'
require 'pp'

class Sandwiches
  DATA_DIR = File.join File.expand_path("..",File.dirname(__FILE__)), "data"
  BREAD_PATH = File.join DATA_DIR, "breads.csv"
  CHEESE_PATH = File.join DATA_DIR, "cheeses.csv"
  MEAT_PATH = File.join DATA_DIR, "proteins.csv"
  SAUCE_PATH = File.join DATA_DIR, "sauces.csv"
  VEGGIE_PATH = File.join DATA_DIR, "veggies.csv"
  SANDWICHES_PATH = File.join DATA_DIR, "newlistofsandwiches.csv"

  def self.sandwiches
    import(SANDWICHES_PATH)
  end

  def self.attributes
    Hash[[BREAD_PATH, CHEESE_PATH, MEAT_PATH, SAUCE_PATH, VEGGIE_PATH].map {|csv| 
      [File.basename(csv, ".csv").to_sym, import(csv)] 
    }]
  end

  def self.import(csv_path)
    CSV.foreach(csv_path, headers: true, header_converters: [:downcase, :symbol])
  end

  def self.generate
    sammy_attr = {
      protein: pick_protein.map {|p| p[:protein] },
      cheese: pick_cheese.map {|c| c[:cheese] },
      bread: pick_bread[:name],
      sauce: pick_sauce.map {|s| s[:spread] },
      veggies: pick_veggies.map {|v| v[:topping] }
    }

    Sandwich.new(%Q[#{sammy_attr[:protein].join(" and ")} on #{sammy_attr[:bread]}], sammy_attr)
  end

  def self.pick_protein
    sample_origin = group_by(attributes[:proteins], :origin).to_a.sample
    sample_origin.last.shuffle.take((1..2).to_a.sample)
  end

  def self.pick_cheese
    attributes[:cheeses].to_a.shuffle.take((0..1).to_a.sample)
  end

  def self.pick_bread
    attributes[:breads].to_a.sample
  end

  def self.pick_veggies
    attributes[:veggies].to_a.sample((0..4).to_a.sample)
  end

  def self.pick_sauce
    sample_family = group_by(attributes[:sauces], :family).to_a.sample((1..2).to_a.sample)
    sample_family.map {|pair| pair.last.sample }
  end

  def self.group_by(set, key)
    set.group_by {|i| i[key] }
  end

  def self.lookup_protein(protein)
      attributes[:proteins].find{|p| p[:protein].eql?(protein)}
  end

  def self.lookup_cheese(cheese)
      attributes[:cheeses].find{|p| p[:cheese].eql?(cheese)}
  end

  attr_reader :set

  def initialize
    @set = Set.new self.class.sandwiches.map do |sandwich|
      Sandwich.new sandwich[:name], sandwich.to_hash.reject {|k,v| k.eql?(:name) }
    end
  end

  def select_by_attribute(attribute, value)
    set.select {|sammy| sammy.attributes[attribute].include? value }
  end

  def random
    set.to_a.sample
  end

end
