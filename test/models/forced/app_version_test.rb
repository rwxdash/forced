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

require 'test_helper'

module Forced
  class AppVersionTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
