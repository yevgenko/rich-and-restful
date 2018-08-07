class OrderPage
  include Capybara::DSL

  def initialize(order)
    @order = order
  end

  def open
    visit "#/orders/#{@order.id}"
    has_status? @order.aasm_state
  end

  def make_payment
    within('#main-region') do
      click_on 'Pay'
    end
  end

  def has_status_pending?
    has_status? 'pending'
  end

  def has_status_paid?
    has_status? 'paid'
  end

  def has_status?(status)
    within('#main-region') do
      assert_text(/#{status}/i)
    end
  end
end
