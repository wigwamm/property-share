class Share
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Token

  has_many :results
  belongs_to :property
  belongs_to :agent
  belongs_to :visitor
  
  field :share_url, type: String
  field :request_url, type: String
  field :referal_token, type: String
  field :anon, type: Mongoid::Boolean

  token :field_name => :referal_token, length: 6
  
  def share_url 
    return 'http://TheURLGoesHere/' + self.share_token
  end

end
