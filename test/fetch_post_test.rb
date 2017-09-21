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
            count: 1
          }
        }
      }.to_json)

    client = IGScrape::Client.new(username)
    assert !client.has_more_posts?
  end
end
