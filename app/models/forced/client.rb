# == Schema Information
#
# Table name: forced_clients
#
#  id         :integer          not null, primary key
#  item_type  :string
#  item_id    :integer
#  identifier :string
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Forced
  class Client < ApplicationRecord
    belongs_to :item, polymorphic: true, optional: true

    has_many :versions, class_name: 'Forced::Version', foreign_key: 'client_id', dependent: :destroy
  end
end
