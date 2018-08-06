class OrdersController < ApplicationController
  respond_to :html, :json

  def index
  end

  def show
    @order = Order.find params[:id]
    respond_with @order
  end
end
