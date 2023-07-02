CarrierWave.configure do |config|
  config.storage    = :aws
  config.aws_bucket = 'adshopping'

  config.aws_credentials = {
    access_key_id:      'AKIAX6XDYQ5DVUW5ZWNT',
    secret_access_key:  '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',
    region:             'eu-north-1'
  }
end
