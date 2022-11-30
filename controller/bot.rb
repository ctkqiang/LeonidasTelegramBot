require 'httparty'
require 'telegram_bot'
require_relative '../model/gold.rb'
require_relative '../controller/util.rb'
require_relative '../configuration/credentials.rb'
require_relative '../controller/capitalcom.rb'

class TelBot 
    def initialize
        @@time = Time.new
        @@bot_name = Credentials.new.env('BOT_NAME')
        @@token = Credentials.new.env('TELEGRAM_BOT_TOKEN')
        @@bot = TelegramBot.new(token: @@token)
        @@gold = Gold.new
        @@util = Util.new
        @@capitalcom = CapitalCom.new
        @@forbidden_words = ["fuck", "🖕", "shit", "stupid"]
    end

    def listen_command()
        puts "Listening for Commands..."

        @@bot.get_updates(fail_silently: true) do |message|

            king_response = [
                "Big mistake. I do not condone this behaviour in my Kingdom! THIS IS SPARTA!", 
                "Watch it!", 
                "Haven't you noticed? We've been sharing our culture with you all morning."
            ]
            
            puts "[#{@@time.inspect}] #{message.from.username} initiate conversation with command \"#{message.text}\""

            command = message.get_command_for(@@bot)

            message.reply do |reply|
                if message.text.include? "help" || command == /help/i
                    reply.text = "https://linktr.ee/johnmelodyme"
                elsif @@forbidden_words.include? message.text
                    reply.text = king_response.sample(2)
                else
                    case command 
                    # Conversation Starter
                    when /start/i
                        reply.text = "Want do you want Soldier?"
                    # Return XAUUSD price (Optional)
                    when /gold/i
                        response = HTTParty.get("https://www.goldapi.io/api/XAU/USD", :headers => {
                            "x-access-token" => Credentials.new.env('GOLD_API_TOKEN')
                        })

                        @@gold.exchange = JSON.parse(response.body)['exchange']
                        @@gold.currency = JSON.parse(response.body)['currency']
                        @@gold.price = JSON.parse(response.body)['price']
                        @@gold.ask = JSON.parse(response.body)['ask']
                        @@gold.bid = JSON.parse(response.body)['bid']
                        @@gold.price_gram_24k = JSON.parse(response.body)['price_gram_24k']
                        @@gold.price_gram_22k = JSON.parse(response.body)['price_gram_22k']
                        @@gold.price_gram_21k = JSON.parse(response.body)['price_gram_21k']
                        @@gold.price_gram_20k = JSON.parse(response.body)['price_gram_20k']
                        @@gold.price_gram_18k = JSON.parse(response.body)['price_gram_18k']
                        
                        response = "
                            Date: #{@@time}\n
                            Current price: \t#{@@gold.price}#{@@gold.currency}\n
                            Ask Price: \t #{@@gold.ask}#{@@gold.currency}\n
                            Bid Price: \t #{@@gold.bid}#{@@gold.currency}\n
                            Price 24k Gram: \t #{@@gold.price_gram_24k}\n
                            Price 22k Gram: \t #{@@gold.price_gram_22k}\n
                            Price 21k Gram: \t #{@@gold.price_gram_21k}\n
                            Price 20k Gram: \t #{@@gold.price_gram_20k}\n
                            Price 18k Gram: \t #{@@gold.price_gram_18k}\n
                        ".gsub(" ","").each_capitalized { |key, value| puts " - #{key}: #{value}" }

                        reply.text = response
                    when /crypto/i
                        reply.text = "Join Me in Huobi Global\nhttps://www.huobi.com/en-us/v/register/double-invite/?invite_code=rjvc6223&inviter_id=11343840" 
                    when /stocks/i
                        reply.text = "Join me in Capital[dot]com https://capital.com/trading/signup?c=enhxunz6&pid=referral&src=inviteFriends"
                    else
                        reply.text = "Do you mind clarify what #{command.inspect} means before I sparta kick you."
                    end 
                end
                
                puts "[#{@@time.inspect}] #{@@bot_name} responded to #{message.from.username}"
                
                reply.send_with(@@bot)
            end 
        end
    end    
end