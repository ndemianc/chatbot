module Chatbot
  module Events
    extend ActiveSupport::Concern

    def say_hello
      puts 'I can help you with answers on all your related questions and help to find a great job! Let\'s talk'
    end

    def get_name
      @current_question = 'Please enter your name'
      ask()
    end

    def get_contact_option
      question = "Hello #{current_user[:name]},\nHow can we reach out to you?"
      format_options = options.reduce('') { |result, opt| result + "\n#{opt.try(:[], :index)}) #{opt.try(:[], :name)}" }
      @current_question = "#{question}\nBy: #{format_options}"
      ask()
    end

    def get_contact_by_option
      @current_question = "Please type your #{option[:subject]}"
      ask()
    end

    def get_time
      @current_question = "What is the best time we can reach out to you?"
      ask()
    end

    def verify_input
      question = [
        "We are going to contact you using #{option[:subject]} #{current_user[option[:event]]}",
        "1) Yes, please",
        "2) Sorry, wrong #{option[:name]}"
      ].join("\n")
      @current_question = question
      ask()
    end

    def create_user
      @current_user_id = service.create_user(current_answer)
    end

    def update_contact_by_option
      key = option[:event]
      service.update_user(@current_user_id, key, current_answer)
    end

    def update_time
      service.update_user(@current_user_id, :time, current_answer)
    end

    def save_selected_option
      ca = current_answer.to_i
      last_position = options.length
      @selected_option = ca.between?(1, last_position) ? ca : last_position
    end

    def get_time_option
      time_options = ['1) ASAP', '2) Morning', '3) Afternoon', '4) Evening']
      @current_question = "What is the best time we can reach out to you?\n#{time_options.join("\n")}"
      ask()
    end
  end
end
