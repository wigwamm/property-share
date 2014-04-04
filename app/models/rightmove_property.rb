class RightmoveProperty
  include Mongoid::Document
  include Mongoid::Timestamps

  before_validate :exists

  def exists
  	reqs = YAML.load(ERB.new(File.read("#{Rails.root}/lib/rightmove.yml")).result)[Rails.env].symbolize_keys!
  	exists_recurse(reqs)
  end

  def exists_recurse(requirements, required=false)
  	requirements.each do |key, value| 
  		if value.is_a?(Hash) 
        if required
          if value == "fields"
            exists_recurse(value)
          end
        else
          exists_recursive(value)
        end
      else
        # Required
        if key == "required"
          required = value
        else
          
        end
      end
  	end
  end

end
