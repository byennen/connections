class User < ActiveRecord::Base
  has_one :profile

  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :university, :graduation_year, :major, :double_major

end
