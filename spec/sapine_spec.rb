require 'spec_helper'

class WithSapine
  include Sapine
end

describe "Sapine" do
  it "adds a method like a scope" do
    WithSapine.respond_to?(:index_options).should be(true)
  end
end