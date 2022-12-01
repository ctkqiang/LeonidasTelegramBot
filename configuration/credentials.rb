require "dotenv"

Dotenv.load("./.env")

class Credentials
    def env(key) ENV[key] end
end 

