class ChangeTestimonialReference < ActiveRecord::Migration
  def change
    add_reference :testimonials, :food_partner
    remove_column :testimonials, :menu_id
  end
end
