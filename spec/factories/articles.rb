# -*- coding: utf-8; -*-
FactoryGirl.define do
  factory :article do
    body <<~EOS
    ■今日のざっくり（東京都知事選挙）
    今日のざっくりはそのものずばり、東京都知事選挙についてです。
    EOS
  end
end
