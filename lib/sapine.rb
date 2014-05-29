require "sapine/version"

module Sapine
  DEFAULT_PER_PAGE = 20

  def self.included(base)
    
  end
  
  def index_options(chain)
    chain = chain.where(state: params[:state]) if params[:state]

    chain = sapine_add_order_by(chain, params[:order_by]) if params[:order_by]

    if params[:per_page].present?
      chain = chain.limit(params[:per_page])
    else
      chain = chain.limit(DEFAULT_PER_PAGE)
    end
    chain = chain.offset((params[:page].to_i - 1) * (params[:per_page] || DEFAULT_PER_PAGE)) if params[:page].present? and params[:page].to_i > 0
    chain
  end

  private
  def sapine_add_order_by(chain, order_by)
    if order_by[0] == "-"
      desc = true
      order_by = order_by[1..order_by.length]
    end
    chain.order("#{order_by} #{desc ? 'DESC' : ''}")
  end
end
