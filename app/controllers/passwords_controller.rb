class PasswordsController < Devise::PasswordsController
  skip_before_filter :verify_authenticity_token 
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    respond_to do |format|
      if successfully_sent?(resource)
        format.html { respond_with resource, :location => after_sending_reset_password_instructions_path_for(resource)  }
        format.json {render :json =>{:message=> "Please Check Your Mail", :success=> true} }
      else
        format.html {respond_with resource, :location => after_sending_reset_password_instructions_path_for(resource)}
        format.json {render :json =>{:message=> "Error Sending Email", :success=> false}}
      end

    end
  end

  def new
    super
  end

  def update
    super
  end

  def edit
    super
  end

# protected
# def after_sending_reset_password_instructions_path_for(resource_name)
# root_url
# end
end