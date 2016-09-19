require 'spec_helper'

describe Chatbot::Model do
  subject { Chatbot::Model }
  let(:first_name) { 'John' }
  let(:second_name) { 'Doe' }
  let(:question) { 'some question' }
  let(:answer) { "#{first_name} #{second_name}" }
  let(:chatbot) { described_class.new(service) }

  before do
    $stdin = StringIO.new(answer)
    allow($stdout).to receive(:puts).and_return('')
  end

  after do
    $stdin = STDIN
  end

  it 'should return correct string from call to gets' do
    expect(gets).to eq(answer)
  end

  describe 'workflow' do
    let(:service) { nil }

    it 'should create a user after event :say_hello' do
      allow(chatbot).to receive(:process_contact!).and_return(true)
      allow(chatbot).to receive(:get_contact_option).and_return(true)
      expect(chatbot).to receive(:create_user)
      chatbot.say_hello!
    end
  end

  describe 'when using valid instance' do
    let(:service) { nil }
    let(:current_answer) { chatbot.instance_variable_get(:@current_answer) }

    before do
      allow(chatbot).to receive(:current_question).and_return(question)
      allow($stdout).to receive(:puts).and_return('')
    end

    it 'should respond to :current_state' do
      expect(chatbot).to respond_to(:current_state)
    end

    it 'current_answer should be initialize with nil' do
      expect(current_answer).to be_nil
    end

    context 'with correct info' do
      it 'should set correct current_answer after ask' do
        expect{chatbot.ask}.to change{chatbot.current_answer}.from(nil).to(answer)
      end
    end

    context 'with incorrect info' do
      it 'should raise an exception is no OPTIONS constant' do
        hide_const("Chatbot::Model::OPTIONS")
        expect{chatbot.options}.to raise_error(NameError)
      end
    end

    context 'using service' do
      let(:service) { double() }
      let(:id) { 'some_id' }

      it 'should return correct user' do
        allow(service).to receive(:current_user).and_return(first_name)
        expect(chatbot.current_user).to eq(first_name)
      end

      it 'should save conversation' do
        allow(chatbot).to receive(:current_user_id).and_return(id)
        allow(chatbot).to receive(:current_answer).and_return(answer)
        expect(service).to receive(:save_conversation).with(id, question, answer).and_return(true)
        expect(chatbot.save_conversation).to be_truthy
      end
    end

    describe '#get_contact_option' do
      let(:question) { "Hello #{current_user[:name]},\nHow can we reach out to you?\nBy: \n1) Phone\n2) Email\n3) I don't want to be contacted" }
      let(:current_user) { {name: first_name} }

      before { allow(chatbot).to receive(:current_user).and_return(current_user) }

      it 'should change current_answer' do
        expect{chatbot.get_contact_option}.to change{
          chatbot.instance_variable_get(:@current_question)
        }.from(nil).to(question)
      end
    end

    describe '#get_contact_by_option' do
      let(:subject) { 'email' }
      let(:question) { "Please type your #{option[:subject]}" }
      let(:option) { {subject: subject} }

      before { allow(chatbot).to receive(:option).and_return(option) }

      it 'should change current_answer' do
        expect{chatbot.get_contact_by_option}.to change{
          chatbot.instance_variable_get(:@current_question)
        }.from(nil).to(question)
      end
    end

    describe '#get_time' do
      let(:question) { "What is the best time we can reach out to you?" }

      it 'should change current_answer' do
        expect{chatbot.get_time}.to change{
          chatbot.instance_variable_get(:@current_question)
        }.from(nil).to(question)
      end
    end

    describe '#get_time_option' do
      let(:time_options) { ['1) ASAP', '2) Morning', '3) Afternoon', '4) Evening'] }
      let(:question) { "What is the best time we can reach out to you?\n#{time_options.join("\n")}" }
      
      it 'should change current_answer' do
        expect{chatbot.get_time_option}.to change{
          chatbot.instance_variable_get(:@current_question)
        }.from(nil).to(question)
      end
    end
  end
end
