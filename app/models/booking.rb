class Booking
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :agent
  belongs_to :property

  field :paid,                      type: Boolean, default: false
  field :stripe_token,              type: String

  validates :agent, :property, presence: true

  def price
    5000
  end

  def direct_pay
    begin
      charge = Stripe::Charge.create(
        amount: price,
        currency: "usd",
        card: stripe_token,
        description: agent.email
      )
      update_attribute :paid, true
    rescue Stripe::CardError => e
      errors.add :base, 'Invalid card. Please check your card again.'
    end
  end

  def wigwamm_pay
    response = WigwammApi.instance.stripe_pay(self)

    if response && response['error'].blank?
      update_attribute :paid, true
      true
    else
      errors.add :base, response['error']['message']
      false
    end
  end

end
