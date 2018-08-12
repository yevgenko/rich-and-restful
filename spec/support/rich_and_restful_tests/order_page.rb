module RichAndRestfulTests
  class OrderPage
    include Capybara::DSL

    def ensure_on(order)
      return if current_path == location_for(order)

      visit location_for(order)
    end

    def location_for(order)
      "#/orders/#{order.id}"
    end

    def pay
      within('#main-region') do
        click_on 'Pay'
      end
    end

    def shows_status?(status)
      within('#main-region') do
        assert_text(/#{status}/i)
      end
    end
  end
end
