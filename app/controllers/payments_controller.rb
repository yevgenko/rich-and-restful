class PaymentsController < ApplicationController
  respond_to :json
  skip_before_action :verify_authenticity_token

  def create
    @order = Order.find params[:order_id]
    @payment = @order.create_payment payment_params
    respond_with @order, @payment
  end

  private

  def payment_params
    params.permit(:amount)
  end
end
