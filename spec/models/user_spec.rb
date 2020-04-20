require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:tracks) }
    it { is_expected.to have_many(:ratings) }
    it { is_expected.to have_many(:identities) }
    it { is_expected.to have_many(:notifications).with_foreign_key(:recipient_id) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to have_secure_password }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(8) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username) }
    it { is_expected.to validate_length_of(:username).is_at_least(4) }

    context 'validate email' do
      it { is_expected.to allow_value('user@example.com').for(:email) }
      it { is_expected.not_to allow_value('user.com').for(:email) }
      it { is_expected.not_to allow_value('user@foo').for(:email) }
    end

    context 'validate username' do
      it { is_expected.to allow_value('user.example').for(:username) }
      it { is_expected.to allow_value('user_example').for(:username) }
      it { is_expected.to allow_value('user-example').for(:username) }
      it { is_expected.not_to allow_value('user example').for(:username) }
      it { is_expected.not_to allow_value('user@foo').for(:username) }
      it { is_expected.not_to allow_value('_user').for(:username) }
      it { is_expected.not_to allow_value('1user').for(:username) }
    end

    context 'not validate password for created user' do
      let!(:user) { create(:user) }
      subject { User.first }

      it do
        subject.username = Faker::Internet.user_name(4)
        subject.valid?
        expect(subject.valid?).to eq true
      end
    end
  end

  describe 'callbacks' do
    context 'send confirm email after update email' do
      let(:user) { create(:user, confirmed: true) }
      subject { -> { user.update(email: 'new_email@example.com') } }

      it do
        subject.call
        expect(user.confirmed).to eq false
      end

      it { expect { subject.call }.to change { ActionMailer::Base.deliveries.count }.by(1) }
    end

    context 'set default avatar' do
      let(:user) { build(:user) }
      subject { -> { user.save } }

      it do
        expect(user[:avatar].present?).to eq false
        subject.call
        expect(user[:avatar].present?).to eq true
      end
    end
  end

  describe 'methods' do
    let!(:user) { create(:user, email: 'user@example.com') }
    let(:new_user) { build(:user, email: 'user@example.com', password: nil) }

    it 'check_uniq_email' do
      expect(new_user.email).to eq 'user@example.com'
      new_user.check_uniq_email
      expect(new_user.email).to eq nil
    end

    it 'missing_password?' do
      expect(new_user.missing_password?).to eq true
      new_user.update(password: '123456789')
      expect(new_user.missing_password?).to eq false
    end

    context 'send_password_reset' do
      subject { -> { user.send_password_reset } }

      it 'change field' do
        expect(user.password_reset_sent_at).to eq nil
        expect(user.password_reset_token).to eq nil
        subject.call
        expect(user.password_reset_sent_at).to be
        expect(user.password_reset_token).to be
      end

      it 'send email' do
        expect { subject.call }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end
end
