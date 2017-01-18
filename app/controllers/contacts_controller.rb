class ContactsController < ApplicationController
  
  # GET request to /contact-us
  # Show new contact form
  def new
    @contact = Contact.new
  end
  
  # Post request to /contacts
  def create
    # Mass assignment of form fields into Contact object
    @contact = Contact.new(contact_params)
    # Save the contact object to the database
    if @contact.save
      # Store form field via params, into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      # Plug variables into Contact mailer email method and send email
      ContactMailer.contact_email(name, email, body).deliver
      # Store success messaage in flash hash
      # and redirect to the new action
      flash[:success] = "Message sent"
      redirect_to contact_us_path
    else
      # If object doesn't save
      # Store errors in flash hash and redirect to new action
      flash[:danger] = @contact.errors.full_messages.join(", ")
      redirect_to contact_us_path
    end
  end
  
  private
  # To collect data from form we need to use
  # Strong parameters and whitelist the form fields
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end

end
