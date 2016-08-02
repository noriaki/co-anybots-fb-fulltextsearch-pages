# -*- coding: utf-8; -*-
require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    described_class.destroy_all
  end

  describe 'FaceboryGirl' do
    it { expect(build(:user)).to be_valid }
  end

  describe 'have fields' do
    it { is_expected.to have_fields(:identifier).of_type(String) }
    it { is_expected.to have_fields(:name).of_type(String) }
    it { is_expected.to have_fields(:access_token).of_type(String) }
    it { is_expected.to be_timestamped_document.with(:created) }
    it { is_expected.to be_timestamped_document.with(:updated) }
  end

  describe 'validations' do
    let(:user) { build(:user) }

    it 'identifierは空でない' do
      user[:identifier] = ''
      is_expected.to validate_presence_of(:identifier)
      expect(user).not_to be_valid
    end

    it 'identifierは重複しない' do
      is_expected.to validate_uniqueness_of(:identifier)
      create(:user)
      expect(user).not_to be_valid
    end

    it 'nameは空でない' do
      user[:name] = ''
      is_expected.to validate_presence_of(:name)
      expect(user).not_to be_valid
    end
  end

  describe 'indexes' do
    it 'identifierにはDBインデックスが張られている' do
      is_expected.to have_index_for(identifier: 1).with_options(
        unique: true, background: true
      )
    end
  end
end
