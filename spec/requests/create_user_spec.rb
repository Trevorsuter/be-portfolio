require 'rails_helper'

RSpec.describe 'create user request' do
  describe 'happy path' do
    before :each do
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {email: "example@email.com",
              password: "Password1!",
              password_confirmation: "Password1!"
            }.to_json

      post api_v1_users_path, headers: headers, params: body

      @user = User.find_by(email: "example@email.com")
      @result = JSON.parse(response.body, symbolize_names: true)
    end

    it 'should have a successful response' do

      expect(response).to be_successful
      expect(response.status).to eq(200)
    end

    it 'should create a new user' do
      
      expect(User.all.length).to eq(1)
      expect(@user).to_not be_nil
    end

    it 'should output the users email and its api key' do
      expected_result = {
        data: {
          id: "#{@user.id}",
          type: "user",
          attributes: {
            email: @user.email,
            api_key: @user.api_key
          }
        }
      }

      expect(@result).to eq(expected_result)
    end
  end
  describe 'sad path' do
    it 'wont create a new user when no params are given' do
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {}.to_json
      
      post api_v1_users_path, headers: headers, params: body

      result = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(User.all.length).to eq(0)
      expect(result[:errors]).to include("Password can't be blank")
      expect(result[:errors]).to include("Email can't be blank")
    end

    it 'wont create a new user if passwords dont match' do
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {email: "example@email.com",
              password: "Password1!",
              password_confirmation: "Password!"
            }.to_json

      post api_v1_users_path, headers: headers, params: body

      result = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(User.all.length).to eq(0)
      expect(result[:errors]).to include("Passwords do not match.")
    end

    it 'wont create a new user if the email is already taken' do
      User.create(email: "example@email.com", password: "Password222")
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {email: "example@email.com",
              password: "Password1!",
              password_confirmation: "Password1!"
            }.to_json

      post api_v1_users_path, headers: headers, params: body

      result = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(User.all.length).to eq(1)
      expect(result[:errors]).to include("Email has already been taken")
    end
  end
end