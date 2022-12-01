require "httparty"
require_relative "../configuration/credentials.rb"

class TelegramServices 
    def initialize
        @@telegram_token = Credentials.new.env("TELEGRAM_TOKEN")
        @@telegram_url = "https://api.telegram.org/bot#{@@telegram_token}/getUpdates"
    end

    def get_chat_id 
        response = HTTParty.get(@@telegram_url)

        return JSON.parse(response.body)["result"][0]["my_chat_member"]["chat"]["id"]
    end 
    
    def post_to_user(message) 
        HTTParty.get("https://api.telegram.org/bot#{@@telegram_token}/sendMessage?chat_id=#{self.get_chat_id}&text=${message}")
    end
end