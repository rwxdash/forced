# == Schema Information
#
# Table name: forced_versions
#
#  id           :integer          not null, primary key
#  client_id    :integer
#  version      :string(255)
#  force_update :boolean          default(FALSE)
#  changelog    :text
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

module Forced
  class Version < ApplicationRecord
    belongs_to :client, class_name: 'Forced::Client'

    validates :version, presence: true, length: { maximum: 255 }
  end
end
