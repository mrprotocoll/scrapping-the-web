# Scrapping static web pages
require "httparty"
require "nokogiri"
require "csv"

url = "https://books.toscrape.com/catalogue/"
books = []

CSV.open(
    "books.csv",
    "w+",
    write_headers: true, headers: %w[Title, Price, Availability]
) do |csv|

    15.times do |x|
        response = HTTParty.get(url+"page-#{x+1}.html")
        if response.code == 200
            puts "Fetched"
        else
            puts "Error: #{response.code}"
        end
    
        document = Nokogiri::HTML4(response.body)
        book_containers = document.css("article.product_pod")
        book_containers.each do |book|
            title = book.css("h3 a").first['title']
            price = book.css(".price_color").text.delete("^0-9.")
            availability = book.css(".availability").text.strip
            csv << [title, price, availability]
        end
    end
end
