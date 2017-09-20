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
          full_name: "Profile Name"
        }
      }.to_json)

    client = IGScrape::Client.new(username)
    assert_equal client.username, username
    assert_equal client.full_name, "Profile Name"
    assert_requested stub
  end
end
