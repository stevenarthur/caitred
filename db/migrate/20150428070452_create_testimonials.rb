class CreateTestimonials < ActiveRecord::Migration
  def change
    create_table :testimonials do |t|
      t.text :text
      t.string :author
      t.belongs_to :menu

      t.timestamps
    end
  end
end
