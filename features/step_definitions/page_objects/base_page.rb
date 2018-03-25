class BasePage
  def initialize(page)
    @page = page
  end

  def heading?
    !@page.first('h1').nil?
  end

  def heading_text
    @page.find('h1').text
  end

  def fill_in(id, text)
    @page.fill_in id, with: text
  end

  def method_missing(method_name, *args)
    if method_name.to_s =~ /^fill_(.+)$/
      field_name = method_name.to_s
                   .gsub('fill_', '')
                   .gsub('_', '-')
      fill_in("js-#{field_name}", *args)
    else
      super
    end
  end
end
