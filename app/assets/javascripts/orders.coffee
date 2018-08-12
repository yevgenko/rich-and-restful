@OrderApp = do (Backbone, $, _) ->
  class PaymentModel extends Backbone.Model

  class OrderModel extends Backbone.Model
    urlRoot: '/orders'

  class OrderView extends Backbone.View
    initialize: ->
      @listenTo @model, "change", @render

    template: _.template("Order ID: <%= id %>, <span class='amount'><%= amount %></span>, <span class='status'><%= status %></span>, <button class='pay'>Pay</button>")
    render: ->
      @$el.html(@template(@model.attributes))
      @

    events:
      'click .pay': ->
        payment = new PaymentModel()
        payment.urlRoot = "/orders/#{@model.id}/payments"
        payment.save { amount: @model.get('amount') },
          success: (payment, response, options) =>
            @model.fetch()

  class IndexView extends Backbone.View
    template: _.template("Hello, World!")
    render: ->
      @$el.html @template()
      @

  class Router extends Backbone.Router
    initialize: (options) ->
      @app = options.app

    routes:
      "":           "index"
      "orders/:id": "show"

    index: ->
      new IndexView({ el: @app.el }).render()

    show: (order_id) ->
      order = new OrderModel({id: order_id}).fetch
        success: (model, response, options) =>
          new OrderView({ el: @app.el, model: model }).render()

  class App
    start: (options) ->
      @environment = options.environment
      @el = options.el
      new Router
        app: @
      Backbone.history.start()

  new App
