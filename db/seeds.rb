# @role0=Role.new
# @role0.name="superuser"
# @role0.save!
# 
# @role1=Role.new
# @role1.name="admin"
# @role1.save!
# 
# @role2=Role.new
# @role2.name="user"
# @role2.save!

@school1=School.new
@school1.name="Mount Carmel Chandigarh"
@school1.phone_no=1234567890
@school1.save!

@user1 = User.new(
      :username              => "superadmin", 
      :email                 => "abc@gmail.com",
      :password              => "password",
      :password_confirmation => "password",
      :role                  => "superuser"       
  )
  @user1.school=@school1
  # @user1.add_role :superuser
  # user.skip_confirmation!
  # user.add_role :admin
  # user.subscription.build(:plan_id=>@plan1.id)
  @user1.save!