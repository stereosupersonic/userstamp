module Ddb #:nodoc:
  module Userstamp
    module Stamper
      def self.included(base) # :nodoc:
        base.extend(ClassMethods)
      end

      module ClassMethods
        def model_stamper
          # don't allow multiple calls
          return if self.included_modules.include?(Ddb::Userstamp::Stamper::InstanceMethods)
          send(:extend, Ddb::Userstamp::Stamper::InstanceMethods)
        end
      end

      module InstanceMethods
        # Used to set the stamper for a particular request. See the Userstamp module for more
        # details on how to use this method.
        def stamper=(object)
          object_stamper = if object.is_a?(ActiveRecord::Base)
            object.send("#{object.class.primary_key}".to_sym)
          else
            object
          end

          Thread.current["#{self.to_s.downcase}_#{self.object_id}_stamper"] = object_stamper
          Thread.current["#{self.to_s.downcase}_#{self.object_id}_stamper_type"] = object.class.name
        end

        # Retrieves the existing stamper for the current request.
        def stamper
          Thread.current["#{self.to_s.downcase}_#{self.object_id}_stamper"]
        end

        def stamper_type
          Thread.current["#{self.to_s.downcase}_#{self.object_id}_stamper_type"]
        end

        # Sets the stamper back to +nil+ to prepare for the next request.
        def reset_stamper
          Thread.current["#{self.to_s.downcase}_#{self.object_id}_stamper"] = nil
          Thread.current["#{self.to_s.downcase}_#{self.object_id}_stamper_type"] = nil
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, Ddb::Userstamp::Stamper) if defined?(Rails) and Rails::VERSION::MAJOR < 3
