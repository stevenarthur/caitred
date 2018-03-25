module WebsiteHelper

  def bordered_header_text(text, optional_klass_name='about')
    content_tag :div, class: "header--#{optional_klass_name} header--content header--banner" do
      content_tag :div, class: "header-content-wrap" do
        content_tag :div, class: "header-content-box" do
          content_tag(:h1){ text }
        end
      end
    end
  end

end
