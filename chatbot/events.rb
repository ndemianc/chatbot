module Chatbot
  module Events
    extend ActiveSupport::Concern

    def start
      puts 'I can help you with answers on all your related questions and help to find a great job! Let\'s talk'
    end

    def save_user
      question 'Please enter your name'
    end

    def email
      question = 'Please type your email address'
    end

    def phone
      question = 'Please type your phone number'
      answer = gets
    end

    def reject
      puts 'In reject'
    end

    def input
      puts 'In input'
    end

    def confirmed
      puts 'In confirmed'
    end

    def wrong_email
      puts 'In wrong_email'
    end

    def wrong_phone
      puts 'In wrong_phone'
    end

    def contact_failed
      puts 'In contact_failed'
    end
  end
end
