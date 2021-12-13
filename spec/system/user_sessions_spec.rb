require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user) }

  describe 'login' do
    context 'when info of authentications are correct' do
      it 'is able to login' do
        visit login_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect(current_path).to eq root_path
        expect(page).to have_content 'login'
      end
    end

    context 'when info of authentication are incorrect' do
      it 'is not be able to login' do
        visit login_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'incorrect_password'
        expect(current_path).to eq login_path
      end
    end
  end

  describe 'logout' do
    before do
      login
    end

    it 'is able to logout' do
      click_on 'ログアウト'
      expect(current_path).to eq login_path
      expect(page).to have_content 'good bye'
    end
  end

end
