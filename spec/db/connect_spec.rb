# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe Mongoid do
  describe 'DBへアクセス' do
    it "接続URI：ENV['DATABASE_URL_TEST']が存在する" do
      expect(ENV['DATABASE_URL_TEST']).not_to be_nil
    end

    it "リモート接続ができる" do
      class C; include Mongoid::Document; end
      expect(C.count).to eq(0)
    end
  end
end
