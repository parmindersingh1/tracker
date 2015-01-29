class SessionsController < Devise::SessionsController
  respond_to :json

  def create
    resource = warden.authenticate!(scope: resource_name, recall: "#{controller_path}#failure")
    sign_in(resource_name, resource)
     respond_to do |format|     
        format.html { redirect_to root_path, notice: 'Logged in  successfully.' }
        format.json { render json: { success: true, path: root_path } }     
    end
    
  end

  def failure
    respond_to do |format|     
        format.html { redirect_to new_user_session_path, notice: 'Login information is incorrect, please try again' }
        format.json { render json: { success: false, errors: ['Login information is incorrect, please try again'] } }     
    end
    
      
  end
end