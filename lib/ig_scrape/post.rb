require 'json'
class IGScrape::Post

  attr_accessor :id, :comment_count, :likes, :is_video, :code, :display_src, :caption, :created_at, :type, :comments

  def initialize payload
    @comments = []
    load_from_payload(payload)
  end

  def self.load_from_shortcode code
    url = "https://www.instagram.com/p/#{code}/?__a=1"
    resp = HTTParty.get(url)

    case resp.code
      when 200
        response = JSON.parse(resp.body)
        payload = response["graphql"]["shortcode_media"]

        post = IGScrape::Post.new(self.edge_timeline_to_payload(payload))
      when 404
        raise ArgumentError.new("Post with #{code} does not exist!")
    end
  end

  def has_more_comments?
    @comments.length < @comment_count
  end

  def load_comments
    while has_more_comments? do
      load_more_comments
    end
  end

  def self.edge_timeline_to_payload node
    {
      "id" => node["id"],
      "__typename" => node["__typename"],
      "is_video" => node["is_video"],
      "code" => node["shortcode"],
      "display_src" => node["display_url"],
      "caption" => (node["edge_media_to_caption"]["edges"].length > 0 ? node["edge_media_to_caption"]["edges"].first["node"]["text"] : ""),
      "date" => node["taken_at_timestamp"],
      "comments" => node["edge_media_to_comment"],
      "likes" => node["edge_media_preview_like"]
    }
  end

  def to_json(*args)
    JSON.generate({
      id: @id,
      code: @code,
      caption: @caption,
      type: @type,
      created_at: @created_at,
      comment_count: @comment_count,
      likes: @likes
    })
  end

  private

    def load_more_comments
      cursor = @comment_page_info["end_cursor"]
      variables = URI.encode_www_form_component("{\"shortcode\":\"#{@code}\",\"first\":20,\"after\":\"#{cursor}\"}")

      url = "https://www.instagram.com/graphql/query/?query_id=17852405266163336&variables=#{variables}"
      resp = HTTParty.get(url)
      response = JSON.parse(resp.body)

      edges = response["data"]["shortcode_media"]["edge_media_to_comment"]["edges"]
      new_comments = edges.collect do |edge|
        IGScrape::Comment.new(edge["node"])
      end

      @comment_page_info = response["data"]["shortcode_media"]["edge_media_to_comment"]["page_info"]
      @comments = @comments.concat(new_comments)
    end

    def load_from_payload payload
      @id = payload["id"]
      @is_video = payload["is_video"]
      @type = payload["__typename"]
      @caption = payload["caption"]
      @created_at = payload["date"]
      @display_src = payload["display_src"]
      @code = payload["code"]
      @likes = payload["likes"]["count"]
      @comment_count = payload["comments"]["count"]
      @comment_page_info = payload["comments"]["page_info"]

      # load comments
      if payload["comments"]["edges"]
        @comments = payload["comments"]["edges"].collect do |edge|
          IGScrape::Comment.new(edge["node"])
        end
      end
    end
end
