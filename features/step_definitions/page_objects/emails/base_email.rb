module Emails
  class BaseEmail
    def initialize(filename)
      i = 0
      while i < 100 && !File.exist?(filename)
        sleep(0.5)
        i += 1
      end
      contents = File.read(filename)
      @message_json = JSON.parse(contents)
    end

    def to_email
      @message_json['to'].first['email']
    end

    def to_name
      @message_json['to'].first['name']
    end

    def message_html
      @message_json['html']
    end
  end
end
