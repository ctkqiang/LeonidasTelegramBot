require "httparty"
require "rubygems"
require_relative "../configuration/credentials.rb"


class CapitalCom 
    extend Gem::Deprecate

    def initialize
        @@capital_apikey = Credentials.new.env("CAPITALCOM_API_KEY")
        @@capital_session = "https://api-capital.backend-capital.com/api/v1/session/encryptionKey"
        @@capital_create_session = "https://api-capital.backend-capital.com/api/v1/session"
    end

    def get_encryption_key
        response = HTTParty.get(@@capital_session, :headers => {
            "X-CAP-API-KEY" => @@capital_apikey
        })

        return JSON.parse(response.body)["encryptionKey"]
    end

    '''
    Refer <a href="https://tinyurl.com/capital-com"> Capital.com Documentation</a>
    '''
    def create_new_session 
        response = HTTParty.post(
            @@capital_create_session, 
            :headers => {    
                "X-CAP-API-KEY" => @@capital_apikey
            }, 
            :body => {
                "identifier" => Credentials.new.env("CAPITALCOM_EMAIL"),
	            "password" => Credentials.new.env("CAPITALCOM_PASSWORD") 
            }
        )

        response.each_capitalized { |key, value| puts " - #{key}: #{value}" }
    end
end