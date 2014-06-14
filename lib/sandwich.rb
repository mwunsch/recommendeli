require 'bing_image_search'

class Sandwich
  attr_reader :name, :attributes

  def initialize(name, attributes)
    @name = name
    @attributes = attributes
  end

  def image
    @image ||= image_search.sample
  end

private

  def image_search
    BingImageSearch.from_env.search("#{@name} sandwich").map {|img| img["MediaUrl"] }
  end

end
