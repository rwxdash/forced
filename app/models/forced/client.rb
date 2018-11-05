module Forced
  class Client < ApplicationRecord
    belongs_to :item, polymorphic: true

    has_many :versions, class_name: 'Forced::Version', foreign_key: 'client_id'
  end
end
