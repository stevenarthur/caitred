module Factories
  class MenuFactory
    ALLOWED_PARAMS = [
      :title,
      :description,
      :price,
      :menu_image_file_name,
      :info_sheet,
      :active,
      :minimum_attendees,
      :long_description,
      :package_conditions,
      :tags,
      :url_slug,
      :priority_order,
      :how_to_serve,
      :meta_title,
      event_type: [],
      dietary_properties: []
    ]

    # TODO: add methods to create / update customers here
    # and remove from controllers
  end
end
