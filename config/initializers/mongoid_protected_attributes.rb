module Mongoid
  def after_commit(*args, &block)
    options = args.pop if args.last.is_a? Hash
    if options
      case args[:on]
      when :create
        after_create(*args, &block)
      when :update
        after_update(*args, &block)
      when :destroy
        after_destroy(*args, &block)
      else
        after_save(*args, &block)
      end
    else
      after_save(*args, &block)
    end
  end
  module Document
    module ProtectedAttributes
      def self.included(base)
        base.class_eval do |base1|
 
          @@protected_attributes = []
 
          include InstanceMethods
          extend ClassMethods
        end
      end
      
      module InstanceMethods
        
        def write_attributes(attrs = nil)
          attrs = attrs.reject {|k,v| (self.class.protected_attribute.include?(k.to_s))}
          process(attrs || {})
          identify if id.blank?
          notify
        end
        
      end
 
      module ClassMethods
        # Define protected attributes
        def attr_protected(*attributes)
          @@protected_attributes = attributes.collect(&:to_s)
        end
 
        def protected_attributes
          @@protected_attributes
        end
      end
      
    end
  end
end