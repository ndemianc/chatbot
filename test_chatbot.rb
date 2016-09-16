require './chatbot'

chatbot = Chatbot::Model.new(Chatbot::Service.new)

chatbot.say_hello!
