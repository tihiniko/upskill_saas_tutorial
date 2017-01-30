class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  belongs_to :plan
  # If Pro user passes validations (email, password, etc.)
  # the call Stripe and tell to set up a subscription
  # upen charging the customer's card
  # Stripe responds back with customer data
  # Store customer.id as the customer token and save the user
  attr_accessor :stripe_card_token
  def save_with_subscription
    if valid?
      customer = Stripe::Customer.create(description: email, plan: plan_id, card: stripe_card_token)
      self.stripe_customer_token = customer.id
    save!
    end
  end
end
