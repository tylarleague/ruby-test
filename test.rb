require 'open-uri'
require 'net/http'
require 'json'
require 'nokogiri'

url = 'https://www.nasa.gov/press-release/nasa-industry-to-collaborate-on-space-communications-by-2025'

def fetch(uri_str)  
    url = URI.parse(uri_str)
    req = Net::HTTP::Get.new(url.path, { 'User-Agent' => 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_2 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8H7 Safari/6533.18.5' })
    response = Net::HTTP.start(url.host, url.port, use_ssl: true) { |http| http.request(req) }
    case response
        when Net::HTTPSuccess     then response.body
        when Net::HTTPRedirection then fetch(response['location'])
        else
            response.error!
    end
end

body_contents =  fetch(url)

# <script>window.forcedRoute = "{API_URL}"</script>
article_url = body_contents[/<script>window\.forcedRoute = "([^>]*)"<\/script>/, 1]

articleResponse = fetch('https://www.nasa.gov/api/2' + article_url)

json_article_response = JSON.parse(articleResponse)
title = json_article_response['_source']['title']
release_no = json_article_response['_source']['release-id'] 
date = json_article_response['_source']['promo-date-time']
article = Nokogiri::HTML(json_article_response['_source']['body']).search('p').text

result = {
    ":title" => title,
    ":date" => date,
    ":release_no" => release_no,
    ":article" => article,
}

puts result