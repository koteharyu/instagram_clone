require 'rails_helper'

RSpec.describe "Posts", type: :system do
  describe 'posts/index' do
    let!(:user) { create(:user) }
    let!(:post_by_user) { create(:post, user: user) }
    let!(:post_1_by_other) { create(:post) }
    let!(:post_2_by_other) { create(:post) }

    context 'when logged in' do
      before do
        login_as
        user.follow(post_1_by_other.user)
      end
      it 'display only post_by_user and posst_1_by_other' do
        visit posts_path
        expect(page).to have_content post_by_user.body
        expect(page).to have_content post_1_by_other.body
        expect(page).to_not have_content post_2_by_other.body
      end
    end

    context 'when user not login' do
      it 'display all posts' do
        visit posts_path
        expect(page).to have_content post_by_user.body
        expect(page).to have_content post_1_by_other.body
        expect(page).to have_content post_2_by_other.body
      end
    end
  end

  describe 'posts/create' do
    xit 'can create a post' do
      login
      visit new_post_path
      within '#posts_form' do
        attach_file '画像', Rails.root.join('spec', 'fixtures', 'fixture.jpg')
        fill_in 'body', with: 'system spec system spec'
        click_button '登録する'
      end
      expect(page).to have_content 'create'
    end
  end

  describe 'posts/edit, update, destroy' do
    let!(:user) { create(:user) }
    let!(:post_by_user) { create(:post, user: user) }
    let!(:post_1_by_other) { create(:post) }
    let!(:post_2_by_other) { create(:post) }

    before do
      login_as
    end

    it 'display edit and delete button on users post' do
      visit posts_path
      within "#post-#{post_by_user.id}" do
        expect(page).to have_css '.edit-button'
      end
    end

    it 'is not display edit button other posts' do
      user.follow(post_1_by_other.user)
      visit posts_path
      within "#post-#{post_1_by_other.id}" do
        expect(page).to_not have_css '.edit-button'
        expect(page).to_not have_css '.delete-button'
      end
    end

    xit 'can upadte own posts' do
      visit edit_post_path(post_by_user)
      within '#posts_form' do
        attach_file '画像', "#{Rails.root}/spec/fixtures/fixture.jpg"
        fill_in 'body', with: 'edit and update'
        click_button '更新する'
      end
      expect(current_path).to eq post_path(post_by_user)
      expect(page).to have_content 'update'
      expect(page).to have_content post_by_user.body
    end

    it 'posts/destroy' do
      visit posts_path
      within "#post-#{post_by_user.id}" do
        page.accept_confirm { find('.delete-button').click }
      end
      expect(page).to have_content 'destroy'
      expect(page).to_not have_content post_by_user.body
    end
  end

  describe 'posts/show' do
    let!(:user) { create(:user) }
    let!(:post_by_user) { create(:post, user: user) }

    before do
      login_as
    end

    xit 'can visit posts/show page' do
      visit post_path(post_by_user)
      expect(page).to have_content post_by_user.body
    end
  end

  describe 'like' do
    let!(:user) { create(:user) }
    let!(:post) { create(:post) }

    before do
      login_as
      user.follow(post.user)
    end

    it 'can like to post' do
      visit posts_path
      expect {
        within "#post-#{post.id}" do
          find('.like-button').click
          expect(page).to have_css '.unlike-button'
        end
      }.to change(user.liked_posts, :count).by(1)
    end

    it 'can unlike to post' do
      user.like(post)
      visit posts_path
      expect {
        within "#post-#{post.id}" do
          find('.unlike-button').click
          expect(page).to have_css '.like-button'
        end
      }.to change(user.liked_posts, :count).by(-1)
    end
  end

  describe 'folow' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }

    before do
      login_as
    end

    it 'can follow other user' do
      visit user_path(other_user)
      expect {
        within "#follow-area-#{other_user.id}" do
          click_on 'Follow'
          expect(page).to have_content 'Unfollow'
        end
      }.to change(user.following, :count).by(1)
    end

    it 'can unfollow other user' do
      user.follow(other_user)
      visit user_path(other_user)
      expect {
        within "#follow-area-#{other_user.id}" do
          click_on 'Unfollow'
          expect(page).to have_content 'Follow'
        end
      }.to change(user.following, :count).by(-1)
    end
  end

end
