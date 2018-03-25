class Storage

  def self.upload file, dir_name
    require 'fog/aws'

    connection = get_connection
    directory = get_directory(connection) 

    directory.files.create(
      :key    => dir_name,
      :body   => file,
      :public => true
    )
  end

  def self.download filename
    require 'fog/aws'

    connection = get_connection
    directory = get_directory(connection)

    file = directory.files.get "invoices/#{filename}"
    url = file.public_url

    #open(url)
    url
    #File.open(file.body)
  end

  def self.get_connection
    Fog::Storage.new({
      :provider                 => 'AWS',
      :aws_access_key_id        => ENV['S3_KEY_ID'],
      :aws_secret_access_key    => ENV['S3_SECRET_KEY'],
      :region => 'ap-southeast-2'
    })
  end

  def self.get_directory(connection)
    connection.directories.get ENV['S3_BUCKET']
  end

end
