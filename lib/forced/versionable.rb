module Forced
  module Versionable
    extend ActiveSupport::Concern

    included do
      has_many :clients, class_name: 'Forced::Client', as: :item
    end
  end
end
