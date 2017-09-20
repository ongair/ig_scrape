require "test_helper"

describe "Posts" do

  it "Can create a post from payload" do
    payload = {
      id: "12345",
      is_video: false,
      code: "54321",
      display_src: "https://instagram.cdn/54321.jpg",
      caption: "Hello world",
      comments: {
        count: 2
      },
      likes: {
        count: 10
      }
    }

    post = IGScrape::Post.new(payload)

    assert_equal post.id, "12345"
    assert_equal post.is_video, false
    assert_equal post.display_src, "https://instagram.cdn/54321.jpg"
    assert_equal post.code, "54321"
    assert_equal post.caption, "Hello world"
    assert_equal post.comment_count, 2
    assert_equal post.likes, 10
  end
end
