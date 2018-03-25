module Admin::TestimonialsHelper

	def testimonial_form_url
    return admin_testimonials_path if @testimonial.id.nil?
    admin_testimonial_path(@testimonial)
	end

end
