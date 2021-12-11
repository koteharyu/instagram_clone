require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'email is neccessary' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include('を入力してください')
    end

    it 'email is uniqueness' do
      create(:user, email: 'model_spec@example.com' )
      same_email_user = build(:user, email: 'model_spec@example.com')
      same_email_user.valid?
      expect(same_email_user.errors[:email]).to include('はすでに存在します')
    end

    it 'username is neccessary' do
      user = build(:user, username: nil)
      user.valid?
      expect(user.errors[:username]).to include('を入力してください')
    end

    it 'password is required' do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include('は3文字以上で入力してください')
    end

    it 'password confirmation is required' do
      user = build(:user, password_confirmation: nil)
      user.valid?
      expect(user.errors[:password_confirmation]).to include('を入力してください')
    end

    it 'password and confirmation is same words' do
      user = build(:user, password_confirmation: 'different')
      user.valid?
      expect(user.errors[:password_confirmation]).to be_present
      expect(user.errors[:password_confirmation]).to include('とパスワードの入力が一致しません')
    end
  end

  describe 'instance methods' do

    let!(:user_a) { create(:user) }
    let!(:user_b) { create(:user) }
    let!(:user_c) { create(:user) }
    let!(:post_by_user_a) { create(:post, user: user_a) }
    let!(:post_by_user_b) { create(:post, user: user_b) }
    let!(:post_by_user_c) { create(:post, user: user_c) }

    describe 'own?' do
      context 'when felf object' do
        it 'return true' do
          expect(user_a.own?(post_by_user_a)).to be true
        end
      end

      context 'others object' do
        it 'return false' do
          expect(user_a.own?(post_by_user_b)).to be false
          expect(user_a.own?(post_by_user_c)).to be false
        end
      end
    end

    describe 'like' do
      context 'when user a does not like other posts' do
        it 'is able to like a post' do
          expect{ user_a.like(post_by_user_a) }.to change { Like.count }.by(1)
          expect{ user_a.like(post_by_user_b) }.to change { Like.count }.by(1)
          expect{ user_a.like(post_by_user_c) }.to change { Like.count }.by(1)
        end
      end

      context 'when user a liked other posts' do
        it 'is not able to like a post' do
          user_a.like(post_by_user_a)
          user_a.like(post_by_user_b)
          user_a.like(post_by_user_c)
          expect{ user_a.like(post_by_user_a) }.to raise_error ActiveRecord::RecordInvalid
          expect{ user_a.like(post_by_user_b) }.to raise_error ActiveRecord::RecordInvalid
          expect{ user_a.like(post_by_user_c) }.to raise_error ActiveRecord::RecordInvalid
        end
      end
    end

    describe 'unlike' do
      it 'decrease like counts' do
        user_a.like(post_by_user_b)
        expect{ user_a.unlike(post_by_user_b) }.to change { Like.count }.by(-1)
      end
    end

    describe 'like?' do
      context 'when user a liked post by user b' do
        it 'return true' do
          user_a.like(post_by_user_b)
          expect(user_a.like?(post_by_user_b)).to be true
        end
      end

      context 'when user a does not like post_by_user_b' do
        it 'return false' do
          expect(user_a.like?(post_by_user_b)).to be false
        end
      end
    end

    describe 'follow' do
      context 'when user a does not follow other users' do
        it 'is able to follow other users' do
          expect{ user_a.follow(user_b) }.to change{ Relationship.count }.by(1)
          expect{ user_a.follow(user_c) }.to change{ Relationship.count }.by(1)
        end
      end

      context 'when user a has followed other users' do
        it 'is not able to follow other user' do
          user_a.follow(user_b)
          user_a.follow(user_c)
          expect{ user_a.follow(user_b) }.to raise_error ActiveRecord::RecordInvalid
          expect{ user_a.follow(user_c) }.to raise_error ActiveRecord::RecordInvalid
        end
      end
    end

    describe 'unfollow' do
      context 'when user a has followed other users' do
        it 'decrease a relationship count' do
          user_a.follow(user_b)
          user_a.follow(user_c)
          expect{ user_a.unfollow(user_b) }.to change{ Relationship.count }.by(-1)
          expect{ user_a.unfollow(user_c) }.to change{ Relationship.count }.by(-1)
        end
      end
    end

    describe 'following?' do
      context 'when user a has followed other users' do
        it 'return true' do
          user_a.follow(user_b)
          user_a.follow(user_c)
          expect(user_a.following?(user_b)).to be true
          expect(user_a.following?(user_c)).to be true
        end
      end

      context 'user a has not followed user b, c yet' do
        it 'return false' do
          expect(user_a.following?(user_b)).to be false
          expect(user_a.following?(user_c)).to be false
        end
      end
    end

    describe 'feed' do
      context 'when user a has followed user b' do
        it 'contains posts of user a' do
          user_a.follow(user_b)
          expect(user_a.feed).to include post_by_user_a
        end

        it 'contains posts of user b' do
          user_a.follow(user_b)
          expect(user_a.feed).to include post_by_user_b
        end

        it 'is not contain posts of user c' do
          user_a.follow(user_b)
          expect(user_a.feed).to_not include post_by_user_c
        end

        it 'count of user a of feeef are 2' do
          user_a.follow(user_b)
          expect(user_a.feed.size).to eq 2
        end
      end
    end

  end
end
