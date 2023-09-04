# frozen_string_literal: true

def tests
  let :query do
    subject.query("SELECT CURRENT_USER() AS user")
  end

  it "return a Mysql2::Result" do
    expect(query).to be_instance_of(Mysql2::Result)
  end

  it "returns a result of size 1" do
    expect(query.to_a.size).to eq(1)
  end
end

RSpec.describe Learn::Github::Actions do
  it "has a version number" do
    expect(Learn::Github::Actions::VERSION).not_to be nil
  end

  let :user do
    ENV.fetch("TEST_DB_USER")
  end

  let :kwargs do
    {
      host: ENV.fetch("TEST_DB_HOST"),
      username: user,
      password: ENV.fetch("TEST_DB_PASS")
    }
  end

  let :client do
    Mysql2::Client.new(**kwargs)
  end

  let :trilogy do
    Trilogy.new(**kwargs)
  end

  describe 'Mysql2' do
    subject do
      client
    end

    tests

    it "returns the correct result" do
      expect(query.to_a.first.first[1]).to match(/^#{user}@.+$/)
    end
  end

  describe 'Trilogy' do
    subject do
      trilogy
    end

    tests

    it "returns the correct result" do
      expect(query.to_a.first.first).to match(/^#{user}@.+$/)
    end
  end
end
