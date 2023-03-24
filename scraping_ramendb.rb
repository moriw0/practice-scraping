require 'open-uri'
require 'nokogiri'
require 'csv'
  
target_url = 'https://tokyo-ramendb.supleks.jp/search?state=tokyo&order=kuchikomi-updated'
base_url = 'https://tokyo-ramendb.supleks.jp/'

html = URI.open(target_url).read
base_doc = Nokogiri::HTML.parse(html)

shop_info_array = []
base_doc.css('a.bglink').each do |link|
  sleep 1
  next_href = link.attribute('href').value
  url = "#{base_url}#{next_href}"
  html = URI.open(url).read
  doc = Nokogiri::HTML.parse(html)
  name = doc.at_css('#shop-data-table').css('td').first.text
  address = doc.at_css('#shop-data-table').css('td')[1].text
  address.sub!(/このお店は「.+」から移転しました。/, '')
  plate = doc.at_css('.plate').text if doc.at_css('.plate')
  p shop_info_array << [name, address, plate]
end

CSV.open("write-sample.csv", "w") do |row|
  row << ["name", "address", "plate"]
  shop_info_array.each do |shop_info|
    row << shop_info
  end
end
