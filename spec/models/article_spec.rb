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

  describe 'searchable', :elasticsearch do
    before(:each, :elasticsearch) do
      described_class.__elasticsearch__.create_index! force: true
      3.times { create(:searchable_article) }
      described_class.__elasticsearch__.refresh_index!
      described_class.__elasticsearch__.client.cluster.health(
        wait_for_status: 'yellow')
    end

    #after(:all, :elasticsearch) do
    #  described_class.__elasticsearch__.client.indices.delete(
    #    index: described_class.index_name) rescue nil
    #end

    # https://github.com/elastic/elasticsearch-rails/blob/master/elasticsearch-model/test/integration/mongoid_basic_test.rb
    it 'インデックスされていて検索できる' do
      response = described_class.search('body:京都')
      expect(response).to be_present
      expect(response.results.size).to eq(1)
      expect(response.records.size).to eq(1)
    end

    it '検索結果を順番に処理できる' do
      result_ids = ['1234567891', '1234567892'];
      response = described_class.search('body:東京')
      expect(response).to be_present
      expect(response.results.map(&:identifier).sort).to eq result_ids.sort
      expect(response.records.map(&:identifier).sort).to eq result_ids.sort
    end

    it 'データを追加するとインデックスにも反映される' do
      create(:article)
      expect(Article.count).to eq(4)
      described_class.__elasticsearch__.refresh_index!
      response = described_class.search('body:東京')
      expect(response).to be_present
      expect(response.results.size).to eq(3)
      expect(response.records.size).to eq(3)
    end

    it 'データを削除するとインデックスにも反映される' do
      Article.first.destroy
      expect(Article.count).to eq(2)
      described_class.__elasticsearch__.refresh_index!
      response = described_class.search('body:東京')
      expect(response).to be_present
      expect(response.results.size).to eq(1)
      expect(response.records.size).to eq(1)
    end

    it 'データを更新するとインデックスにも反映される' do
      Article.first.update_attributes(body: '大阪府知事選挙に出馬する')
      described_class.__elasticsearch__.refresh_index!
      response = described_class.search('body:東京')
      expect(response).to be_present
      expect(response.results.size).to eq(1)
      expect(response.records.size).to eq(1)
      response = described_class.search('body:大阪')
      expect(response).to be_present
      expect(response.results.size).to eq(1)
      expect(response.records.size).to eq(1)
    end
  end
end
