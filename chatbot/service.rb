module Chatbot

  class UserCreationError < StandardError
  end

  class Service
    def save_conversation(user_id, question, answer)
      user_profile(user_id).save_message({ question: question, answer: answer })
    end

    def create_user(name)
      user = user_model.create(name: name)
      if user
        return user.id
      else
        raise UserCreationError, 'User creation failed'
      end
    end

    def current_user(id)
      user_model.find(id)
    end

    def update_user(id, field, value)
      user_profile(id).update_attribute(field, value)
    end

    private

    def user_model
      User
    end

    def user_profile(user_id)
      @user ||= user_model.find(user_id)
    end
  end
end
