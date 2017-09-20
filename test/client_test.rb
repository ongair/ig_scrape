require "test_helper"

# class ClientTest < Minitest::Test
#
#   test 'can create an instagram client' do
#   end
# end

describe "Clients" do

  it "Can create an instagram client" do

    username = "ig_user"

    stub = stub_request(:get, "https://www.instagram.com/#{username}/?__a=1")
      .to_return(status: 200, body: {
        user: {
          full_name: "Profile Name",
          followed_by: {
            count: 100
          },
          id: "12345",
          follows: {
            count: 50
          },
          media: {
            count: 200
          }
        }
      }.to_json)

    client = IGScrape::Client.new(username)
    assert_equal client.username, username
    assert_equal client.full_name, "Profile Name"
    assert_equal client.follower_count, 100
    assert_equal client.follows_count, 50
    assert_equal client.id, "12345"
    assert_equal client.post_count, 200
    assert_requested stub
  end
end
