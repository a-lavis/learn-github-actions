# frozen_string_literal: true

RSpec.describe Learn::Github::Actions do
  it "has a version number" do
    expect(Learn::Github::Actions::VERSION).not_to be nil
  end

  let :user do
    ENV.fetch("TEST_DB_USER")
  end

  let :client do
    Mysql2::Client.new(
      host: ENV.fetch("TEST_DB_HOST"),
      username: user,
      password: ENV.fetch("TEST_DB_PASS")
    )
  end

  describe "#query" do
    let :query do
      client.query("SELECT CURRENT_USER() AS user")
    end

    it "return a Mysql2::Result" do
      expect(query).to be_instance_of(Mysql2::Result)
    end

    it "returns a result of size 1" do
      expect(query.to_a.size).to eq(1)
    end

    it "returns the correct result" do
      expect(query.to_a.first.first.second).to match(/^#{user}@.+$/)
    end
  end
end
