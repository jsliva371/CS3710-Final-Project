require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {FactoryBot.build(:user) }

  context 'Should validate' do 
    it 'with valid fields ' do 
      expect(user).to be_valid
    end 
  end
end

