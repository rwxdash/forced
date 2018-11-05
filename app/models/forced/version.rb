module Forced
  class Version < ApplicationRecord
    belongs_to :client, class_name: 'Forced::Client'

    validates :version, presence: true, length: { maximum: 255 }
  end
end
