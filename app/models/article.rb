class Article
  include Mongoid::Document
  include Mongoid::Timestamps

  field :identifier, type: String
  field :body, type: String

  index({ identifier: 1 }, { unique: true, background: true })

  validates_presence_of :identifier
  validates_uniqueness_of :identifier
  validates_presence_of :body
end
