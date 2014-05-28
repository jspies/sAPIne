require "sapine/version"

module Sapine
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def index_options(params)
      chain = self.where(true)
      chain = chain.where(state: params[:state]) if params[:state]
      chain = chain.order(params[:order_by]) if params[:order_by]
      if params[:limit].present?
        chain = chain.limit(params[:limit])
        chain = chain.offset(params[:page]) if params[:page].present?
      end
      chain
    end
  end
end
