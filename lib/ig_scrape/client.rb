# require 'httparty'
# module IGScrape
#
#   class Client
#
#     def initialize(username)
#       @username = username
#       load_profile(username)
#     end
#
#
#     private
#
#       def load_profile username
#         url = "https://www.instagram.com/#{username}/?__a=1"
#         resp = HTTParty.get(url)
#       end
#   end
# end

require 'httparty'
class IGScrape::Client

  attr_accessor :username, :full_name

  def initialize(username)
    @username = username
    load_profile
  end

  private

    def load_profile
      url = "https://www.instagram.com/#{@username}/?__a=1"
      resp = HTTParty.get(url)

      response = JSON.parse(resp.body)
      @full_name = response["user"]["full_name"]      
    end
end
