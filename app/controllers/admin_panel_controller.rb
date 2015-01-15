class AdminPanelController < ApplicationController
  def users
    @users =User.all
  end

  def edit_role    
    @user=User.find_by_id(params[:user])
  end
  def update_role
    @user=User.find_by_id(params[:user_id])
    @role =params[:role]
    # @user.roles=@role
    # @user.save
    # @user.add_role @role.name
    # user.roles = params[:role_ids].present? ? Role.find_all_by_id(params[:role_ids]) : [ ]
    @user.update_attributes(:role => @role) unless @role.nil?
    redirect_to :action => "users"
  end
end
