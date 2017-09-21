require "test_helper"

describe "Posts" do

  it "Can create a post from payload" do
    payload = {
      "id" => "12345",
      "is_video" => false,
      "code" => "54321",
      "display_src" => "https://instagram.cdn/54321.jpg",
      "caption" => "Hello world",
      "date" => 1505914786,
      "comments" => {
        "count" => 2
      },
      "likes" => {
        "count" => 10
      }
    }

    post = IGScrape::Post.new(payload)

    assert_equal post.id, "12345"
    assert_equal post.is_video, false
    assert_equal post.display_src, "https://instagram.cdn/54321.jpg"
    assert_equal post.code, "54321"
    assert_equal post.caption, "Hello world"
    assert_equal post.comment_count, 2
    assert_equal post.created_at, 1505914786
    assert_equal post.likes, 10
  end

  it "can create a comment from the payload" do
    payload = {
      id: "1234",
      text: "Hi",
      created_at: 1505915455,
      owner: {
        id: "12345",
        profile_pic_url: "https://instagram.com/a.jpg",
        username: "claudinhamarm"
      }
    }

    comment = IGScrape::Comment.new(payload)

    assert_equal comment.id, "1234"
    assert_equal comment.text, "Hi"
    assert_equal comment.created_at, 1505915455
    assert_equal comment.author_id, "12345"
    assert_equal comment.author_name, "claudinhamarm"
    assert_equal comment.author_profile_pic, "https://instagram.com/a.jpg"
  end
end
