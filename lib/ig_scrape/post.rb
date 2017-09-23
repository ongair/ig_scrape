class IGScrape::Post

  attr_accessor :id, :comment_count, :likes, :is_video, :code, :display_src, :caption, :created_at, :type

  def initialize payload
    load_from_payload(payload)
  end

  def self.edge_timeline_to_payload edge_payload
    node = edge_payload["node"]
    {
      "id" => node["id"],
      "__typename" => node["__typename"],
      "is_video" => node["is_video"],
      "code" => node["shortcode"],
      "display_src" => node["display_url"],
      "caption" => node["edge_media_to_caption"]["edges"].first["node"]["text"],
      "date" => node["taken_at_timestamp"],
      "comments" => node["edge_media_to_comment"],
      "likes" => node["edge_media_preview_like"]
    }
  end

  private
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
    end
end
