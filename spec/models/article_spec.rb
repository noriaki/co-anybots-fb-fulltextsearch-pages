# -*- coding: utf-8; -*-
require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'FaceboryGirl' do
    it { expect(build(:article)).to be_valid }
  end

  describe 'have fields' do
    it { is_expected.to have_fields(:body).of_type(String) }
    it { is_expected.to be_timestamped_document.with(:created) }
    it { is_expected.to be_timestamped_document.with(:updated) }
  end

  describe 'validations' do
    let(:article) { build(:article) }

    it 'bodyは空でない' do
      article[:body] = ''
      is_expected.to validate_presence_of(:body)
      expect(article).not_to be_valid
    end
  end
end
