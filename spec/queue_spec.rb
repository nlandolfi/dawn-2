
if ENV["COVERAGE"]
  require "simplecov"; SimpleCov.start
end

require_relative "./spec_helper"


describe Dawn::Queue do
  it "creates" do
    expect(Dawn::Queue.create).to_not eq(nil)
  end
end

