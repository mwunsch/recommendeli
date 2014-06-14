require 'net/http'
require 'uri'
require 'json'

class BingImageSearch
  BING_URI = "https://api.datamarket.azure.com/Bing/Search/v1/Image"

  def self.from_env
    new("wIvWku2pOSL2ZtwEomeOb3w0xfu18qXKHg+Go8R0duc")
  end

  def initialize(account_key)
    @account_key = account_key
  end

  def search(query)
    json = get_response uri({ 
      "Query" => "'#{query}'",
      "$top" => 5,
      "$format" => "JSON",
      "ImageFilters" => "'Size:Large+Aspect:Square'"
    })
    json["d"]["results"]
  end

  def get_response(url)
    JSON.parse(request(url).body)
  end

  def request(url)
    req = Net::HTTP::Get.new(url)
    req.basic_auth @account_key, @account_key
    Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
      http.request(req)
    end
  end

  def uri(parameters={})
    url = ::URI.parse(BING_URI)
    url.query = URI.encode_www_form(parameters) unless parameters.empty?
    url
  end
end
