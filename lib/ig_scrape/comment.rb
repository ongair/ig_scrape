class IGScrape::Comment

  attr_accessor :id, :text, :created_at, :author_id, :author_name, :author_profile_pic

  def initialize(payload)
    load_from_payload(payload)
  end

  def to_json(*args)
    JSON.generate({
      id: @id,
      text: @text,
      created_at: @created_at,
      author_id: @author_id,
      author_name: @author_name,
      author_profile_pic: @author_profile_pic
    })
  end

  private

    def load_from_payload payload
      @id = payload["id"]
      @text = payload["text"]
      @created_at = payload["created_at"]
      @author_id = payload["owner"]["id"]
      @author_profile_pic = payload["owner"]["profile_pic_url"]
      @author_name = payload["owner"]["username"]
    end
end
