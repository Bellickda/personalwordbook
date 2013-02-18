class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username
  # attr_accessible :title, :body
  
  has_many :account, dependent: :destroy
  has_many :services, :dependent => :destroy
  
  #add
  serialize :pastgroupid
  validates :username, :presence => true, :uniqueness => true
  
  def apply_omniauth(omniauth)
    case omniauth['provider']
    when "twitter"
      email = ''    # Twitter API never returns the email address
    when "facebook"
      email = ''
    end
    self.email = email if self.email.blank?
    connect_service(omniauth)
  end
  
  def connect_service(omniauth)
    case omniauth['provider']
    when "twitter"
      omniauth['uid'] ?  uid =  omniauth['uid'] : uid = ''
      omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
      token = (omniauth['credentials']['token'] rescue nil)
      secret = (omniauth['credentials']['secret'] rescue nil)
    when "facebook"
      omniauth['uid'] ?  uid =  omniauth['uid'] : uid = ''
      omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
      token = (omniauth['credentials']['token'] rescue nil)
      secret = (omniauth['credentials']['secret'] rescue nil)
    end
    services.build(:provider => provider,:uid => uid,:token => token, :secret => secret)
  end
  
  def password_required?  
    (services.empty? || !password.blank?) && super  
  end
  
  def twitter
    unless @twitter_user
      provider = self.services.find_by_provider('twitter')
      @twitter_user = Twitter::Client.new(:oauth_token => provider.token, :oauth_token_secret => provider.secret) rescue nil
    end
    @twitter_user
  end
  
  def facebook
    @fb_user ||= FbGraph::User.me(self.services.find_by_provider('facebook').token)
  end
  
end
