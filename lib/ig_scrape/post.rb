class IGScrape::Post

  attr_accessor :id, :comment_count, :likes, :is_video, :code, :display_src, :caption

  def initialize payload
    load_from_payload(payload)
  end

  private
    def load_from_payload payload


      @id = payload[:id]
      @is_video = payload[:is_video]
      @caption = payload[:caption]
      @display_src = payload[:display_src]
      @code = payload[:code]
      @likes = payload[:likes][:count]
      @comment_count = payload[:comments][:count]
    end
end
