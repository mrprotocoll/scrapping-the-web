# Scrapping dynamic web pages
require "selenium-webdriver"
require "csv"

options = Selenium::WebDriver::Chrome::Options.new
# options.headless!
options.add_argument('--headless')
driver = Selenium::WebDriver.for(:chrome, options: options)

driver.get "http://quotes.toscrape.com/js/"
quotes = []
while true do
    quotes_container = driver.find_elements(css: ".quote")
    quotes_container.each do |quote|
        text = quote.find_element(css: ".text").attribute("textContent")
        author = quote.find_element(css: ".author").attribute("textContent")

        quotes << [text, author]
    end
    begin
        driver.find_element(css: ".next >a").click #click next button
    rescue => exception
        break # next button is not found
    end
end

CSV.open("quotes.csv","w+", write_headers: true, headers: %w[Quote, Author]) do |csv|
    quotes.each {|quote| csv << quote }
end