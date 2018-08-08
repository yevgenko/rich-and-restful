module RichAndRestfulTests
  class ApplicationRunner
    def pay_for(order)
      page_for(order).pay
    end

    def has_shown_order_is_pending?(order)
      page_for(order).shows_status? 'pending'
    end

    def has_shown_order_is_paid?(order)
      page_for(order).shows_status? 'paid'
    end

    private

    def page_for(order)
      OrderPage.new.tap do |page|
        page.ensure_on order
      end
    end
  end
end
