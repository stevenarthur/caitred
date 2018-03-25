Premailer::Rails.config.merge!(
  remove_comments: true,
  adapter: :nokogiri,
  preserve_styles: true, 
  remove_ids: true
)
