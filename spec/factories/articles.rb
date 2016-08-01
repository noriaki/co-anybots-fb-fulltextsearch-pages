# -*- coding: utf-8; -*-
FactoryGirl.define do
  factory :article do
    identifier '1234567890'
    body <<~EOS
    ■今日のざっくり（東京都知事選挙）
    今日のざっくりはそのものずばり、東京都知事選挙についてです。
    EOS
  end

  searchable_bodies = [
    '東京都知事選挙に出馬する',
    '東京特許許可局の早口言葉',
    '京都の清水寺の来場者数は'
  ]
  factory :searchable_article, class: Article do
    sequence(:identifier) {|n| (1234567891 + (n-1) % searchable_bodies.size).to_s }
    sequence(:body) {|n| searchable_bodies[(n-1) % searchable_bodies.size] }
  end
end
