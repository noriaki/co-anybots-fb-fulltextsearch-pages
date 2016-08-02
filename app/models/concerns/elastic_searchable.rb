module ElasticSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name [
      Rails.application.engine_name, Rails.env, self.model_name.singular
    ].join('_')
  end
end
