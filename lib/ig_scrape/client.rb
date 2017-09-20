require 'httparty'
class IGScrape::Client

  attr_accessor :username, :full_name, :follower_count, :follows_count, :id ,:post_count

  def initialize(username)
    @username = username
    load_profile
  end

  private

    def load_profile
      url = "https://www.instagram.com/#{@username}/?__a=1"
      resp = HTTParty.get(url)

      response = JSON.parse(resp.body)
      user = response["user"]
      @full_name = user["full_name"]
      @follower_count = user["followed_by"]["count"]
      @follows_count = user["follows"]["count"]
      @id = user["id"]
      @post_count = user["media"]["count"]
    end
end
