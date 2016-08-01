Mongoid.logger = ActiveSupport::Logger.new(
  Rails.root.join("log/mongoid-#{Rails.env}.log").to_s, 'daily')
Mongoid.logger.formatter = Rails.application.config.log_formatter.dup
