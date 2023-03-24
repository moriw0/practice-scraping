# Usage 
# $ ruby output_html.rb > ***.html

require 'open-uri'
require 'nokogiri'

url = 'https://arao99.github.io/zenn_scraping/js_sample1.html'

html = URI.open(url).read
doc = Nokogiri::HTML.parse(html)
p doc.at_css('title').text
puts html
