require "sapine/version"

module Sapine
  DEFAULT_PER_PAGE = 20
  DEFAULT_PAGE     = 1

  def self.included(base)
  end

  def set_default_meta
    @_sapine_meta = {
      pages: 0,
      page: page,
      per_page: per_page,
      count: 0
    }
  end

  def index_options(chain)
    set_default_meta unless @_sapine_meta
    chain = sapine_add_order_by(chain, params[:order_by]) if params[:order_by]

    @_sapine_meta[:count] = chain.count
    @_sapine_meta[:pages] = (@_sapine_meta[:count] / per_page.to_f).ceil

    chain = chain.limit(per_page)
    chain = chain.offset(offset)

    chain
  end

  # for elastic search
  def elasticsearch_index_options(chain)
    set_default_meta unless @_sapine_meta
    @_sapine_meta[:count] = chain.total_entries
    @_sapine_meta[:pages] = (@_sapine_meta[:count] / per_page.to_f).ceil

    chain
  end

  def api_meta
    set_default_meta unless @_sapine_meta
    @_sapine_meta
  end

  def order_by
    return {} unless params[:order_by].present?

    order = {}
    order_values = Array(params[:order_by])

    order_values.each do |value|
      if value.starts_with? "-"
        order[value[1..-1]] = 'desc'

      elsif value.starts_with? "+"
        order[value[1..-1]] = 'asc'

      else
        order[value] = 'asc'
      end
    end
    order
  end

  def offset
    if params[:page].present? and params[:page].to_i > 0
      ((params[:page].to_i - 1) * per_page)
    else
      0
    end
  end



  private

  def per_page
    params[:per_page] ? params[:per_page].to_i : DEFAULT_PER_PAGE
  end

  def page
    params[:page] ? params[:page].to_i : DEFAULT_PAGE
  end

  def sapine_add_order_by(chain, order_by)
    if order_by[0] == "-"
      desc = true
      order_by = order_by[1..order_by.length]
    end
    chain.order("#{order_by} #{desc ? 'DESC' : ''}")
  end
end
