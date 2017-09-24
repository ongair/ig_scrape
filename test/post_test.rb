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
      "id" => "1234",
      "text" => "Hi",
      "created_at" => 1505915455,
      "owner" => {
        "id" => "12345",
        "profile_pic_url" => "https://instagram.com/a.jpg",
        "username" => "claudinhamarm"
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

  it "can convert edge to standard post payload" do
    edge_payload = {
      "node" => {
        "id" => "12345",
        "__typename" => "GraphImage",
        "edge_media_to_caption" => {
          "edges"=> [
            {
              "node" => {
                "text" => "Caption"
              }
            }
          ]
        },
        "shortcode" => "BZF6YwmFSb1",
        "edge_media_to_comment" => {
          "count" => 15
        },
        "edge_media_preview_like" => {
          "count" => 10
        },
        "taken_at_timestamp" => 1234890,
        "display_url" => "https://instagram.fnbo2-1.fna.fbcdn.net/test.jpg",
        "is_video" => false
      }
    }

    payload = {
      "id" => "12345",
      "__typename" => "GraphImage",
      "is_video" => false,
      "code" => "BZF6YwmFSb1",
      "display_src" => "https://instagram.fnbo2-1.fna.fbcdn.net/test.jpg",
      "caption" => "Caption",
      "date" => 1234890,
      "comments" => {
        "count" => 15
      },
      "likes" => {
        "count" => 10
      }
    }

    assert_equal IGScrape::Post.edge_timeline_to_payload(edge_payload["node"]), payload
  end

  it "Can load a post from the shortcode" do

    code = "BZTc6zHloW8"
    stub = stub_request(:get, "https://www.instagram.com/p/#{code}/?__a=1")
      .to_return(status: 200, body: {
        graphql: {
          shortcode_media: {
            id: '123',
            shortcode: code,
            display_url: "https://instagram.fbcdn.net/123.jpg",
            edge_media_to_caption: { edges: [ { node: { text: "Caption" } } ]},
            edge_media_to_comment: {
              count: 1,
              page_info: {
                has_next_page: false,
                end_cursor: nil,
              },
              edges: [
                {
                  node: {
                    id: "54321",
                    text: "Do you have no 3",
                    created_at: 1505998980,
                    owner: {
                      id: "67890",
                      profile_pic_url: "https://instagram.net/67890.jpg",
                      username: "rosem123"
                    }
                  }
                }
              ]
            },
            edge_media_preview_like: { count: 5 }
          }
        }
      }.to_json
    )

    post = IGScrape::Post.load_from_shortcode(code)
    assert_requested stub
    assert_equal post.code, code
    assert_equal post.comment_count, post.comments.count

  end

  it "Can load more comments for a post" do
    code = "BZTc6zHloW8"
    cursor = "cursor"
    post_stub = stub_request(:get, "https://www.instagram.com/p/#{code}/?__a=1")
      .to_return(status: 200, body: {
        graphql: {
          shortcode_media: {
            id: '123',
            shortcode: code,
            display_url: "https://instagram.fbcdn.net/123.jpg",
            edge_media_to_caption: { edges: [ { node: { text: "Caption" } } ]},
            edge_media_to_comment: {
              count: 2,
              page_info: {
                has_next_page: true,
                end_cursor: cursor,
              },
              edges: [
                {
                  node: {
                    id: "54321",
                    text: "Do you have no 3",
                    created_at: 1505998980,
                    owner: {
                      id: "67890",
                      profile_pic_url: "https://instagram.net/67890.jpg",
                      username: "rosem123"
                    }
                  }
                }
              ]
            },
            edge_media_preview_like: { count: 5 }
          }
        }
      }.to_json
    )

    variables = URI.encode_www_form_component("{\"shortcode\":\"#{code}\",\"first\":20,\"after\":\"#{cursor}\"}")
    url = "https://www.instagram.com/graphql/query/?query_id=17852405266163336&variables=#{variables}"

    more_stub = stub_request(:get, url)
      .to_return(status: 200, body: {
        data: {
          shortcode_media: {
            edge_media_to_comment: {
              count: 2,
              page_info: {
                has_next_page: false,
                end_cursor: nil
              },
              edges: [
                {
                  node: {
                    id: "12345",
                    text: "Do you have no 4",
                    created_at: 1505998981,
                    owner: {
                      id: "67891",
                      profile_pic_url: "https://instagram.net/67890.jpg",
                      username: "rosem321"
                    }
                  }
                }
              ]
            }
          }
        }
      }.to_json
    )

    post = IGScrape::Post.load_from_shortcode(code)
    assert_requested post_stub
    assert post.has_more_comments?

    post.load_comments
    assert_requested more_stub
    assert !post.has_more_comments?
  end
end
