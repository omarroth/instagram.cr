require "http"
require "uri"
require "json"
require "./crypto"

USERNAME      = "emkruse1234"
INSTAGRAM_URL = URI.parse("https://www.instagram.com")

client = HTTP::Client.new(INSTAGRAM_URL)
headers = HTTP::Headers.new
headers["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36"

html = client.get("/#{USERNAME}/", headers).body
shared_data = html.match(/sharedData = (?<info>.*?);<\/script>/).try &.["info"]
if shared_data
  shared_data = JSON.parse(shared_data)
else
  raise "Could not get info for user #{USERNAME}"
end

csrf_token = shared_data["config"]["csrf_token"].as_s
headers["Cookie"] = "csrftoken=#{csrf_token}"

user = shared_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]

user_id = user["id"]
rhx_gis = shared_data["rhx_gis"].as_s

has_next_page = true
i = 0

loop do
  has_next_page = user["edge_owner_to_timeline_media"]["page_info"]["has_next_page"].as_bool
  end_cursor = user["edge_owner_to_timeline_media"]["page_info"]["end_cursor"].as_s?

  if !has_next_page
    break
  end

  query_id = "50d3631032cf38ebe1a2d758524e3492"
  variables = {
    "id"    => user_id,
    "first" => i + 50,
    "after" => end_cursor,
  }.to_json

  headers["X-Instagram-GIS"] = sign(rhx_gis + ":" + variables)

  response = JSON.parse(client.get("/graphql/query/?query_hash=#{query_id}&variables=#{variables}", headers).body)
  user = response["data"]["user"]

  File.write("dump/#{i}-#{i + 50}.json", user.to_pretty_json)
  i += 50

  print "Page: #{i / 50}\r"
end
