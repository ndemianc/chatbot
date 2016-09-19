require 'spec_helper'

describe Chatbot::Service do
  subject { Chatbot::Service }
  let(:id) { 'some_id' }
  let(:user_profile) { instance_double('user_profile') }
  let(:user_model) { double }
  let(:first_name) { 'John' }
  let(:second_name) { 'Doe' }
  let(:question) { 'some question' }
  let(:answer) { "#{first_name} #{second_name}" }
  let(:user_params) { {id: id} }

  describe 'call to instance method' do
    let(:service) { subject.new }
    before do
      allow(service).to receive(:user_profile).and_return(user_profile)
    end

    describe '#save_conversation' do
      before { allow(user_profile).to receive(:save_message).with({question:question, answer:answer}).and_return true }

      it 'should be successful' do
        expect(service.save_conversation(id, question, answer)).to be_truthy
      end
    end

    describe '#create_user' do
      before do
        allow(service).to receive(:user_model).and_return user_model
        allow(user_profile).to receive(:id).and_return id
      end

      context 'with good user_model' do
        before { allow(user_model).to receive(:create).and_return user_profile }

        it 'should be return id' do
          expect(service.create_user(first_name)).to eq(id)
        end
      end

      context 'with bad user_model' do
        before { allow(user_model).to receive(:create).and_return false }

        it 'should throw an error' do
          expect{service.create_user(first_name)}.to raise_error(Chatbot::UserCreationError, 'User creation failed')
        end
      end
    end

    describe '#current_user' do
      before { allow(service).to receive(:user_model).and_return user_model }
      before { allow(user_model).to receive(:find).and_return user_profile }

      it 'should be successful' do
        expect(service.current_user(id)).to eq(user_profile)
      end
    end

    describe '#update_user' do
      let(:name) { 'name' }
      
      it 'should be successful' do
        expect(user_profile).to receive(:update_attribute).with(name, first_name)
        service.update_user(id, name, first_name)
      end
    end
  end
end
