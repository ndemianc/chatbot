require 'active_record'
require 'workflow'
require 'interactor'

require 'chatbot/version'
require 'chatbot/model'
require 'chatbot/events'
require 'chatbot/services'

module Chatbot
  def self.version
    VERSION
  end
end
