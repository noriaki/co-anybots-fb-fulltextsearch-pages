elastic_search_logger = ActiveSupport::Logger.new(
  Rails.root.join("log/elasticsearch-#{Rails.env}.log").to_s, 'daily')
Elasticsearch::Model.client = Elasticsearch::Client.new(
  host: ENV['ELASTICSEARCH_URL'], log: true, logger: elastic_search_logger
)
