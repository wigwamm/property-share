module ApplicationHelper

  def cest_le_weekend?(time)
    r = ( time.wday == 6 ) ? true : ( time.wday == 0 ? true : false )
    return r
  end

end
