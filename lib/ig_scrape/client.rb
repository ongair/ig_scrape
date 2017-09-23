require 'httparty'

class IGScrape::Client

  attr_accessor :username, :full_name, :follower_count, :follows_count, :id ,:post_count, :profile_pic_url, :posts

  def initialize(username)
    @username = username
    @posts = []
    load_profile
  end

  # def posts
  # end

  def has_more_posts?
    @posts.length < @post_count
  end

  def loaded_post_count
    @posts.length
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
      @profile_pic_url = user["profile_pic_url"]

      media = user["media"]["nodes"]
      if media
        @posts = media.collect do |node|
          IGScrape::Post.new(node)
        end
      end
    end

end
