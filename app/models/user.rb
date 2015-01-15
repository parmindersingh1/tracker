class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :login
  belongs_to :school
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,  :authentication_keys => [:login]
  validates :username,  :uniqueness => { :case_sensitive => false }
  validates :school_id, :presence => true
  ROLES = %w[superuser admin user]
  # before_create :create_login

  # def create_login
  # email = self.email.split(/@/)
  # login_taken = User.where( :login => email[0]).first
  # unless login_taken
  # self.login = email[0]
  # else
  # self.login = self.email
  # end
  # end

  before_create :user_role
  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  def user_role
    self.role = "user" if self.role.blank?
  end
end
