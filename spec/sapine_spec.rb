require 'spec_helper'

class WithSapine
  include Sapine
end

describe "Sapine" do
  it "adds a method for common API index options" do
    WithSapine.new.respond_to?(:index_options).should be(true)
  end

  context "index_options" do
    before do
      @ws = WithSapine.new
    end

    it "adds an order" do
      @ws.stub(:params).and_return({order_by: "state"})
      chain = @ws.index_options(TestModel)
      chain.to_sql.include?("ORDER BY state").should be(true)
    end

    it "adds a negative order" do
      @ws.stub(:params).and_return({order_by: "-state"})
      chain = @ws.index_options(TestModel)
      chain.to_sql.include?("ORDER BY state DESC").should be(true)
    end

    it "adds the default limit" do
      @ws.stub(:params).and_return({})
      chain = @ws.index_options(TestModel)
      chain.to_sql.should eql("SELECT  \"test_models\".* FROM \"test_models\"  LIMIT 20")
    end

    it "adds a limit with a per_page" do
      @ws.stub(:params).and_return({per_page: 1})
      chain = @ws.index_options(TestModel)
      chain.to_sql.should eql("SELECT  \"test_models\".* FROM \"test_models\"  LIMIT 1")
    end

    it "adds an offset with a page param" do
      @ws.stub(:params).and_return({page: 2})
      chain = @ws.index_options(TestModel)
      chain.to_sql.should eql("SELECT  \"test_models\".* FROM \"test_models\"  LIMIT 20 OFFSET 20")
    end

    it "returns the count in api_meta" do
      @ws.stub(:params).and_return({})
      chain = @ws.index_options(TestModel)
      @ws.api_meta.count.should be(4)
    end
  end

  context "meta" do
    before do
      @ws = WithSapine.new
      @ws.stub(:params).and_return({per_page: 12})
    end

    it "returns the params per_page" do
      @ws.api_meta[:per_page].should eql(12)
    end

    it "calculates the pages" do
      TestModel.create
      @ws.index_options(TestModel)
      @ws.api_meta[:pages].should eql(1)
    end
  end


end