require 'forced/versionable'

module Forced
  module Model
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def is_versionable
        send :include, Forced::Versionable
      end
    end
  end
end
