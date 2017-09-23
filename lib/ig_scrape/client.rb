require 'httparty'

class IGScrape::Client

  attr_accessor :username, :full_name, :follower_count, :follows_count, :id ,:post_count, :profile_pic_url, :posts

  def initialize(username)
    @username = username
    @posts = []
    load_profile
  end

  def load
    while has_more_posts? do
      load_more_posts
    end
  end

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
      @page_info = user["media"]["page_info"]
      @profile_pic_url = user["profile_pic_url"]

      media = user["media"]["nodes"]
      if media
        @posts = media.collect do |node|
          IGScrape::Post.new(node)
        end
      end
    end

    def load_more_posts
      cursor = @page_info["end_cursor"]

      variables = URI.encode_www_form_component("{\"id\":\"#{@id}\",\"first\":12,\"after\":\"#{cursor}\"}")
      url = "https://www.instagram.com/graphql/query/?query_id=17888483320059182&variables=#{variables}"

      resp = HTTParty.get(url)
      response = JSON.parse(resp.body)
      timeline = response["data"]["user"]["edge_owner_to_timeline_media"]
      @page_info = timeline["page_info"]
      new_posts = timeline["edges"].collect do |edge|
        IGScrape::Post.new(IGScrape::Post.edge_timeline_to_payload(edge))
      end

      @posts = @posts.concat(new_posts)
    end

end
