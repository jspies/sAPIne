require 'spec_helper'

class WithSapine
  include Sapine
end

describe "Sapine" do
  it "adds a method for common API index options" do
    WithSapine.respond_to?(:index_options).should be(true)
  end
end