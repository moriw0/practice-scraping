require "selenium-webdriver"
require 'csv'

options = Selenium::WebDriver::Chrome::Options.new
options.headless!
driver = Selenium::WebDriver.for :chrome, options: options

target_url = 'https://tokyo-ramendb.supleks.jp/search?state=tokyo&q=%E7%A7%8B%E8%91%89%E5%8E%9F'
driver.get(target_url)

url_array = []
driver.find_elements(:css, 'a.bglink').each do |link|
  url_array << link.attribute("href")
end

shop_info_array = []
url_array.each do |url|
  driver.get(url)
  sleep 1
  p name = driver.find_element(:id, "shop-data-table").find_elements(:tag_name, "td")[0].text
  p address = driver.find_element(:id, "shop-data-table").find_elements(:tag_name, "td")[1].text
  address.sub!(/\nこのお店は「.+」から移転しました。/, '')
  p plate = driver.find_element(:class, 'plate').text if driver.find_elements(:class, 'plate').size >= 1
  shop_info_array << [name, address, plate]
end

CSV.open("write-sample.csv", "w") do |row|
  row << ["name", "address", "plate"]
  shop_info_array.each do |shop_info|
    row << shop_info
  end
end
