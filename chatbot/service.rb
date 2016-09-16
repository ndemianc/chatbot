module Chatbot
  class Service
    def save_conversation(user_id, question, answer)
      user_profile(user_id).messages.create(question: question, answer: answer)
    end

    def create_user(name)
      user = User.create(name: name)
      if user.save
        return user.id
      else
        throw 'User creation failed'
      end
    end

    def current_user(id)
      User.find(id)
    end

    def update_user(id, field, value)
      user_profile(id).update_attribute(field, value)
    end

    private

    def user_profile(user_id)
      User.find(user_id)
    end
  end
end
