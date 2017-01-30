class Users::RegistrationsController < Devise::RegistrationsController
  # Extend default Devise gem behaviour so the users signing up
  # with the Pro account save with a special Stripe subscription function
  # Otherwise devise signs up user as usual
  def create
    super do |resource|
      if params[:plan]
        resource.plan_id = params[:plan]
        if resource.plan_id == 2
          resource.save_with_subscription
        else
          resource.save
        end
      end
    end
  end
end