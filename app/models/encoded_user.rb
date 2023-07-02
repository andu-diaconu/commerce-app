class EncodedUser < ApplicationRecord

  def call_adshopping_ai
    require 'net/http'
    require 'uri'
    require 'json'

    url = URI.parse('http://adshopping-ai-402cd377ee3e.herokuapp.com/recommend')
    params = { user_id: self.value }

    url.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
      recommends = response.body
      results = JSON.parse(recommends)
      return results
    else
      return nil
    end
  end

end