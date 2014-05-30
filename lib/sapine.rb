require "sapine/version"

module Sapine
  DEFAULT_PER_PAGE = 20

  def self.included(base)
  end

  def set_default_meta
    @_sapine_meta = {
      pages: 0,
      page: 1,
      per_page: DEFAULT_PER_PAGE,
      count: 0
    }    
  end
  
  def index_options(chain)
    set_default_meta unless @_sapine_meta
    chain = sapine_add_order_by(chain, params[:order_by]) if params[:order_by]

    @_sapine_meta[:count] = chain.count
    @_sapine_meta[:pages] = (@_sapine_meta[:count] / per_page).ceil

    chain = chain.limit(per_page)
    chain = chain.offset((params[:page].to_i - 1) * per_page) if params[:page].present? and params[:page].to_i > 0

    chain
  end

  def api_meta
    @_sapine_meta
  end

  private

  def per_page
    params[:per_page] || DEFAULT_PER_PAGE
  end

  def sapine_add_order_by(chain, order_by)
    if order_by[0] == "-"
      desc = true
      order_by = order_by[1..order_by.length]
    end
    chain.order("#{order_by} #{desc ? 'DESC' : ''}")
  end
end
