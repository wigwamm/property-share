class Share
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Token

  has_many :results
  belongs_to :agent
  
  field :share_token, type: String
  field :refer_url, type: String
  token :field_name => :share_token, length: 6

  #Need to be fixed when Property Class is implemented
  field :property_id, type: String
  
  def share_url 
    return 'http://TheURLGoesHere/' + self.share_token
  end
  
  def on_visit
    @result = self.results.new(traveled_urls:[self.refer_url,'CURRENTURLGOESHERE'])
  end
  
  validates :property_id, presence: true, allow_blank: false
  validates :agent_id, presence: true, allow_blank: false
  validates :refer_url, presence: true, allow_blank: false
end
