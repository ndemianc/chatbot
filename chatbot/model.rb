module Chatbot
  class Model
    include Workflow
    include Chatbot::Events

    OPTIONS = [
      { event: :phone, name: 'Phone', subject: 'phone number', index: 1 },
      { event: :email, name: 'Email', subject: 'email address', index: 2 },
      { event: :reject, name: 'I don\'t want to be contacted', subject: nil, index: 3, reject: true }
    ].freeze

    def initialize(service = nil)
      @service = service
      @current_user = {}
      @current_question
      @current_answer
      @selected_option
      @contacts = []
      @best_time
      @conversation = []
    end

    workflow do
      state :new do
        event :say_hello, :transitions_to => :name
      end
      state :name do
        event :process_name, :transitions_to => :contact
        on_entry do
          get_name
          process_name!
        end
        on_exit do
          create_user
        end
      end
      state :contact do
        event :process_contact, :transitions_to => :email, :if => proc { |model| model.option[:event] == :email }
        event :process_contact, :transitions_to => :phone, :if => proc { |model| model.option[:event] == :phone }
        event :process_contact, :transitions_to => :end, :if => proc { |model| model.option[:event] == :reject }
        on_entry do
          get_contact_option
          save_selected_option
          process_contact!
        end
      end
      state :email do
        event :process_email, :transitions_to => :confirm_input
        on_entry do
          get_contact_by_option
          update_user
          process_email!
        end
      end
      state :phone do
        event :process_phone, :transitions_to => :time
        on_entry do
          get_contact_by_option
          update_user
          process_phone!
        end
      end
      state :time do
        event :process_time, :transitions_to => :confirm_input
        on_entry do
          get_time_option
          update_time
          process_time!
        end
      end
      state :confirm_input do
        event :process_input, :transition_to => :happy_end, :if => proc { |model| model.current_answer == '1' }
        event :process_input, :transition_to => :email, :if => proc { |model| model.option[:event] == :email }
        event :process_input, :transition_to => :phone, :if => proc { |model| model.option[:event] == :phone }
        on_entry do
          verify_input
          process_input!
        end
      end
      state :happy_end
      state :end
      on_transition do |from, to, triggering_event, *args|
        save_conversation()
      end
    end

    def option
      result = options.select do |hash|
        hash[:index] == selected_option
      end
      result.first
    end

    def current_answer
      @current_answer
    end

    def check_property(prop)
      proc { |model| model.option[:event] == prop.to_sym }
    end

    private

    attr_reader :service, :current_user, :current_question, :contact_type, :contacts, :best_time, :selected_option

    def ask
      puts current_question
      @current_answer = gets.chomp!
    end

    def options
      OPTIONS
    end
  end
end
