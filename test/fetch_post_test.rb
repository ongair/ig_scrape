require "test_helper"

describe "Can fetch posts" do
  username = "testaccount"

  it "Does not need to fetch posts if there are less than 12" do

    stub = stub_request(:get, "https://www.instagram.com/#{username}/?__a=1")
      .to_return(status: 200, body: {
        user: {
          full_name: "Profile Name",
          followed_by: {
            count: 100
          },
          id: "12345",
          profile_pic_url: "https://instagram.fnbo3-1.fna.fbcdn.net/12345.jpg",
          follows: {
            count: 50
          },
          media: {
            nodes: [
              {
                id: "12345",
                is_video: false,
                code: "54321",
                display_src: "https://instagram.cdn/54321.jpg",
                caption: "Hello world",
                comments: {
                  count: 2
                },
                "likes": {
                  count: 10
                }
              }
            ],
            count: 1,
            page_info: {
              has_next_page: false
            }
          }
        }
      }.to_json)

    client = IGScrape::Client.new(username)
    assert_requested stub
    assert !client.has_more_posts?
  end

  it "Needs to fetch more posts if there are more than 12" do

    posts = (0..11).to_a.collect do |p|
      {
        id: p,
        is_video: false,
        code: "#{p}",
        display_src: "https://instagram.cdn/#{p}.jpg",
        caption: "Post #{p}",
        comments: {
          count: p
        },
        "likes": {
          count: p
        }
      }
    end

    stub = stub_request(:get, "https://www.instagram.com/#{username}/?__a=1")
      .to_return(status: 200, body: {
        user: {
          full_name: "Profile Name",
          followed_by: {
            count: 100
          },
          id: "12345",
          profile_pic_url: "https://instagram.fnbo3-1.fna.fbcdn.net/12345.jpg",
          follows: {
            count: 50
          },
          media: {
            nodes: posts,
            count: 13,
            page_info: {
              has_next_page: true,
              end_cursor: "123457890"
            }
          }
        }
      }.to_json
    )

    client = IGScrape::Client.new(username)
    assert_requested stub
    assert client.has_more_posts?
    assert_equal client.loaded_post_count, 12


    variables = URI.encode_www_form_component("{\"id\":\"12345\",\"first\":12,\"after\":\"123457890\"}")

    next_url = "https://www.instagram.com/graphql/query/?query_id=17888483320059182&variables=#{variables}"
    next_stub = stub_request(:get, next_url)
      .to_return(status: 200, body: {
        data: {
          user: {
            edge_owner_to_timeline_media: {
              page_info: {
                has_next_page: false
              },
              edges: [
                {
                  node: {
                    id: '12345',
                    edge_media_to_caption: { edges: [ { node: { text: "Caption" } } ]},
                    edge_media_to_comment: { count: 5 },
                    edge_media_preview_like: { count: 5 }
                  }
                }
              ]
            }
          }
        }
      }.to_json
    )

    client.load
    assert !client.has_more_posts?
    assert_requested next_stub
  end
end
