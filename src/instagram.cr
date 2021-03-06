# "instagram.cr" (which is a library for crawling Instagram)
# Copyright (C) 2018  Omar Roth

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

require "http"
require "uri"
require "json"
require "./instagram/*"

module Instagram
  INSTAGRAM_URL = URI.parse("https://www.instagram.com")

  def self.get_user_page(username : String, end_cursor : String | Nil = nil)
    client = HTTP::Client.new(INSTAGRAM_URL)
    headers = HTTP::Headers.new
    headers["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36"

    html = client.get("/#{username}/", headers).body
    shared_data = html.match(/_sharedData = (?<info>.*?);<\/script>/).try &.["info"]
    if shared_data
      shared_data = JSON.parse(shared_data)
    else
      raise "Could not get info for user #{username}"
    end

    csrf_token = shared_data["config"]["csrf_token"].as_s
    headers["Cookie"] = "csrftoken=#{csrf_token}"

    user = shared_data["entry_data"]["ProfilePage"][0]["graphql"]["user"]

    user_id = user["id"]

    if !end_cursor
      return user
    end

    query_id = "66eb9403e44cc12e5b5ecda48b667d41"
    variables = {
      "id"    => user_id,
      "first" => 50,
      "after" => end_cursor,
    }.to_json

    response = JSON.parse(client.get("/graphql/query/?query_hash=#{query_id}&variables=#{variables}", headers).body)

    user = response["data"]["user"]

    return user
  end
end
