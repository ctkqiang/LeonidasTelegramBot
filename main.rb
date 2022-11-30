require_relative 'controller/bot.rb'

telegram_bot = TelBot.new().listen_command()