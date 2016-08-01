# -*- coding: utf-8; -*-
require 'rails_helper'

RSpec.describe Article, type: :model do
  before(:each) do
    Article.destroy_all
  end

  describe 'FaceboryGirl' do
    it { expect(build(:article)).to be_valid }
  end

  describe 'have fields' do
    it { is_expected.to have_fields(:identifier).of_type(String) }
    it { is_expected.to have_fields(:body).of_type(String) }
    it { is_expected.to be_timestamped_document.with(:created) }
    it { is_expected.to be_timestamped_document.with(:updated) }
  end

  describe 'validations' do
    let(:article) { build(:article) }

    it 'identifierは空でない' do
      article[:identifier] = ''
      is_expected.to validate_presence_of(:identifier)
      expect(article).not_to be_valid
    end

    it 'identifierは重複しない' do
      is_expected.to validate_uniqueness_of(:identifier)
      create(:article)
      expect(article).not_to be_valid
    end

    it 'bodyは空でない' do
      article[:body] = ''
      is_expected.to validate_presence_of(:body)
      expect(article).not_to be_valid
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
