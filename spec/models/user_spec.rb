require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it {should validate_presence_of :email}
    it {should validate_uniqueness_of :email}
    it {should validate_presence_of :password}
    it {should have_secure_password}
  end

  describe 'after creation' do
    it 'will generate an api key' do
      user = User.create!(email: 'test@example.com', password: 'Password1!')

      expect(user.api_key).to_not be_nil
      expect(user.api_key).to be_a(String)
    end
  end
end
