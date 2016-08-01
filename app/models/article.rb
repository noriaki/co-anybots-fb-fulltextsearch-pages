class Article
  include Mongoid::Document
  include Mongoid::Timestamps

  field :identifier, type: String
  field :body, type: String

  index({ identifier: 1 }, { unique: true, background: true })

  validates_presence_of :identifier
  validates_uniqueness_of :identifier
  validates_presence_of :body

  include ElasticSearchable

  settings do
    mappings dynamic: 'false' do
      indexes :identifier
      indexes :body, analyzer: 'kuromoji'
    end
  end

  def as_indexed_json(options = {})
    as_json(only: [:identifier, :body])
  end
end
