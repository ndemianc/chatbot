module Chatbot
  class Model
    include Workflow
    include Chatbot::Events

    workflow do
      state :new do
        event :start, :transitions_to => :enter_name
      end
      state :enter_name do
        event :save_user, :transitions_to => :get_contact
      end
      state :get_contact do
        event :email, :transitions_to => :get_input
        event :phone, :transitions_to => :get_input
        event :reject, :transitions_to => :failed
      end
      state :get_input do
        event :input, :transitions_to => :confirm_input
      end
      state :confirm_input do
        event :confirmed, :transitions_to => :happy_end
        event :wrong_email, :transitions_to => :get_input
        event :wrong_phone, :transitions_to => :get_input
      end
      state :failed do
        event :contact_failed, :transitions_to => :end
      end
      state :happy_end
      state :end
      on_transition do |from, to, triggering_event, *args|
      end
    end
  end
end
