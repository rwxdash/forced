require 'forced/engine'
require 'forced/base'
require 'forced/response'
require 'forced/messages'
require 'forced/is_versionable'

module Forced
  ActiveSupport.on_load(:active_record) do
    include Forced::Model
  end
end
