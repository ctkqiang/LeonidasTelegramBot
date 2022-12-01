require "httparty"
require_relative "../model/news.rb"
require_relative "../configuration/credentials.rb"

class News
    def initialize
        @@news = NewsModel.new
        @@gold_news_endpoint = "https://newsdata.io/api/1/news?apikey=#{Credentials.new.env("NEWSDATA_API")}&language=en"
    end

    def get_news
        response = HTTParty.get(@@gold_news_endpoint)
        body = JSON.parse(response.body)["results"]

        body.each do |news|
            @@news.title = news["title"]
            @@news.description = news["description"]
            @@news.link = news["link"]
            @@news.pubDate = news["pubDate"]

            @@news.to_map(
                @@news.title = news["title"],
                @@news.description = news["description"],
                @@news.link = news["link"],
                @@news.pubDate = news["pubDate"]
            )
        end

        return "#{@@news.title}\n\n#{@@news.description}\n\n#{@@news.link}"
    end
end