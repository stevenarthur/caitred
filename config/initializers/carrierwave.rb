CarrierWave.configure do |config|
  config.storage = :fog
  config.fog_credentials = {
    :provider               => 'AWS',                                       # required
    :aws_access_key_id      => ENV['S3_KEY_ID'],                            # required
    :aws_secret_access_key  => ENV['S3_SECRET_KEY'],                        # required
    :region                 => 'ap-southeast-2',                            # optional, defaults to 'us-east-1'
    # :host                   => 's3.example.com',                          # optional, defaults to nil
    # :endpoint               => 'https://s3.example.com:8080'              # optional, defaults to nil
  }
  config.fog_directory  = ENV['S3_BUCKET']                                  # required
  config.cache_dir = "#{Rails.root}/tmp/"
  config.fog_public     = true                                              # optional, defaults to true
  # config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}          # optional, defaults to {}
end
