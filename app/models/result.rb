class Result
  include Mongoid::Document
  include Mongoid::Timestamps

  #Validations
  validate :time_on_site_is_valid
  
  belongs_to :share
  
  #Fields
  field :booked, type: Boolean, default: false
  field :traveled_urls, type: Array, default: []
  field :start_time, type: Time
  field :time_on_site, type: Float, default: 0.0
  field :cookie_ident, type: String

  #Methods
  def add_current_url(current_url)
    if self.start_time == nil
      self.start_time = Time.now
    end
    if self.start_time.to_f-self.time_on_site.to_f-Time.now.to_f > 0.001
      puts 'hi'
      self.traveled_urls.push(current_url)
      self.time_on_site = Time.now - self.start_time
    end
  end

  private
  
  def time_on_site_is_valid
    if self.start_time.to_i > Time.now.to_i - self.time_on_site
      errors.add(:start_time, 'Time cannot be greater than current time sub time on site')
    end
  end
    

end
