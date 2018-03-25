module Admin
  class IncomingMailController < AdminController
    protect_from_forgery with: :null_session
    before_action :authenticate

    def from_supplier
      mails = params[:mandrill_events] || []
      mails = JSON.parse(mails)
      mails.each do |mail|
        Mandrill::SupplierMessageProcessor.new(mail, request.base_url).process
      end
      head :ok
    end

    private

    def authenticate
      digest = OpenSSL::Digest.new('sha1')
      encrypted = OpenSSL::HMAC.digest(digest, ENV['MANDRILL_KEY'], signature)
      expected = Base64.encode64(encrypted).strip
      fail 'Not authenticated' unless expected == request.headers['X-Mandrill-Signature']
    end

    def signature
      base = request.base_url + request.path
      request.POST.sort.each do |key, val|
        base << key
        base << val
      end
      base
    end
  end
end
