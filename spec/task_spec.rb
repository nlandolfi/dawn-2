
if ENV["COVERAGE"]
  require "simplecov"; SimpleCov.start
end

require_relative "./spec_helper"

describe Dawn::Task do
  it "creates" do
    expect(Dawn::Task.create).to_not eq(nil)
  end
end
