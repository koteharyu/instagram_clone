require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe 'create a user' do
    context 'when info of auth are correct' do
      it 'is able to create a user' do
        visit signup_path
        fill_in 'user name', with: 'system'
        fill_in 'email', with: 'system@example.com'
        fill_in 'password', with: 'password'
        fill_in 'password_confirmation', with: 'password'
        click_button 'sign up'
        expect(current_path).to eq root_path
        expect(page).to have_content 'create a user'
      end
    end

    context 'when info of auth are incorrect' do
      it 'is not able to create a user' do
        visit signup_path
        fill_in 'user name', with: ''
        fill_in 'email', with: ''
        fill_in 'password', with: ''
        fill_in 'password_confirmation', with: ''
        click_button 'sign up'
        expect(page).to have_content 'ユーザー名を入力してください'
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(page).to have_content 'パスワードは6文字以上で入力してください'
        expect(page).to have_content '確認用を入力してください'
      end
    end
  end
end
