require 'spec_helper'

class WithSapine
  include Sapine
end

describe "Sapine" do
  it "adds a method for common API index options" do
    expect(WithSapine.new.respond_to?(:index_options)).to be_truthy
  end

  context "index_options" do
    before do
      @ws = WithSapine.new
    end

    it "adds an order" do
      @ws.stub(:params).and_return({order_by: "state"})
      chain = @ws.index_options(TestModel)
      expect(chain.to_sql.include?("ORDER BY state")).to be_truthy
    end

    it "adds a negative order" do
      @ws.stub(:params).and_return({order_by: "-state"})
      chain = @ws.index_options(TestModel)
      expect(chain.to_sql.include?("ORDER BY state DESC")).to be_truthy
    end

    it "adds the default limit" do
      @ws.stub(:params).and_return({})
      chain = @ws.index_options(TestModel)
      expect(chain.to_sql).to eql("SELECT  \"test_models\".* FROM \"test_models\" LIMIT 20 OFFSET 0")
    end

    it "adds a limit with a per_page" do
      @ws.stub(:params).and_return({per_page: 1})
      chain = @ws.index_options(TestModel)
      expect(chain.to_sql).to eql("SELECT  \"test_models\".* FROM \"test_models\" LIMIT 1 OFFSET 0")
    end

    it "adds an offset with a page param" do
      @ws.stub(:params).and_return({page: 2})
      chain = @ws.index_options(TestModel)
      expect(chain.to_sql).to eql("SELECT  \"test_models\".* FROM \"test_models\" LIMIT 20 OFFSET 20")
    end

    it "returns the count in api_meta" do
      @ws.stub(:params).and_return({})
      chain = @ws.index_options(TestModel)
      expect(@ws.api_meta[:count]).to eql(0)
    end
  end

  context "meta" do
    before do
      @ws = WithSapine.new
      @ws.stub(:params).and_return({ per_page: 12, page: 3 })
    end

    it "returns the params per_page" do
      expect(@ws.api_meta[:per_page]).to eql(12)
    end

    it "calculates the pages" do
      TestModel.create
      @ws.index_options(TestModel)
      expect(@ws.api_meta[:pages]).to eql(1)
    end

    it 'returns the passed in page number' do
      expect(@ws.api_meta[:page]).to eql(3)
    end
  end

  context "elasticsearch" do
    before do
      @ws = WithSapine.new
      @ws.stub(:params).and_return({page: 2, per_page: 2})
    end

    it "should return valid meta data" do

      obj = double()
      obj.stub(:total_entries).and_return(5)
      @ws.elasticsearch_index_options(obj)

      expect(@ws.api_meta[:count]).to eql(5)
      expect(@ws.api_meta[:per_page]).to eql(2)
      expect(@ws.offset).to eql(2)
    end
  end


end
