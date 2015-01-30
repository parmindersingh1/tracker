class SessionsController < Devise::SessionsController
def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    respond_to do |format|  
      format.html { respond_with resource, :location => after_sign_in_path_for(resource) }  
      format.json {  
         return render :json => {  :success => true, 
           :user => resource
         } 
      }  
    end
  end
  def destroy
    sign_out(resource_name)
    set_flash_message(:notice, :signed_out) if is_navigational_format?
    respond_to do |format|  
      format.html { redirect_to new_user_session_path }  
      format.json {  
         return render json: { success: true }, status: :ok
      }  
    end
  end
  
  protected
  def ensure_params_exist
    return unless params[:user_login].blank?
    render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
  end
 
  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end
  
  
end
