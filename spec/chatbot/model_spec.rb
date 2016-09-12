require 'spec_helper'

describe Chatbot::Model do
  let(:chatbot) { described_class.new }

  it 'should respond to :current_state' do
    expect(chatbot).to respond_to(:current_state)
  end
end
