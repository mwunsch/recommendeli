require 'bing_image_search'

class Sandwich
  attr_reader :name, :attributes

  def initialize(name, attributes)
    @name = name
    @attributes = Hash[attributes.map do |k,v|
      value = if v.nil?
        []
      elsif v.respond_to?(:split)
        v.split(",").map(&:strip)
      else
        v
      end
      [k, value]
    end]
  end

  def image
    @image ||= image_search.sample
  end

  def slug
    name.downcase.gsub(/\s/, "_")
  end

  def filled_attributes
    attributes.reject {|k,v| v.nil? || v.empty? }
  end

  def description
    sample_attributes = Hash[filled_attributes.to_a.sample((2..4).to_a.sample)]
    desc = []
    if sample_attributes.has_key?(:origin)
      desc << "This tantilizing delight is from the #{sample_attributes[:origin].first} region."
    end
    if sample_attributes.has_key?(:mood)
      desc << "This sandwich is perfect if you feel #{sample_attributes[:mood].first}."
    end
    if sample_attributes.has_key?(:protein)
      protein = Sandwiches.lookup_protein(sample_attributes[:protein].first)
      desc << "#{protein[:protein].capitalize} is a #{protein[:quality]} protein." unless protein.nil?
    end
    if sample_attributes.has_key?(:cheese)
      cheese = Sandwiches.lookup_cheese(sample_attributes[:cheese].first)
      desc << "This cheese is a #{cheese[:boldness]} #{cheese[:quantifier]} cheese." unless protein.nil?
    end
    desc.shuffle.join(" ")
  end

private

  def image_search
    BingImageSearch.from_env.search("#{@name} sandwich").map {|img| img["MediaUrl"] }
  end

end
