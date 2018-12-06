require "./spec_helper"

describe Instagram do
  it "Tests signature function" do
    Instagram::Crypto.sign("").should eq("d41d8cd98f00b204e9800998ecf8427e")
    Instagram::Crypto.sign(%q({"id":00000001,first:50,end_cursor:"QVF..."})).should eq("8f0dfeb616f2b926db66eed2e9a14fd0")
    Instagram::Crypto.sign("\x02").should eq("9e688c58a5487b8eaf69c9e1005ad0bf")

    variables = {
      "id"    => "787132",
      "first" => 12,
      "after" => "QVFENm5tNU5IaXdYb0p6bHJOTW9wODd4THNWcEttRmM1THdFWnVRQndOYVZjMjA4Y0N6NWxHVUdOWnBFODdSTnE3ekVzMFVXZnRZbDhpbk8tcVhfTVRxQQ==",
    }.to_json

    rhx_gis = "feaeb07155b1f1afe8950c6c883a41d5"

    Instagram::Crypto.sign(rhx_gis + ":" + variables).should eq("e33a4845c47938ca423fbc15fe521093")
  end
end
