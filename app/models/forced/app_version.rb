# == Schema Information
#
# Table name: forced_app_versions
#
#  id           :integer          not null, primary key
#  client       :integer
#  version      :string(255)
#  force_update :boolean          default(FALSE)
#  changelog    :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

module Forced
  class AppVersion < ApplicationRecord
    enum client: Forced::CLIENT_ENUM

    validates :client, presence: true
    validates :version, presence: true, length: { maximum: 255 }
  end
end
