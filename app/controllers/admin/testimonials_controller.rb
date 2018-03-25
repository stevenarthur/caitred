module Admin
  class TestimonialsController < AdminController
    before_action :find_testimonial, only: [:edit, :update, :destroy]
    before_action :require_admin_authentication

    def index
      @testimonials = Testimonial.all.order :created_at
    end

    def edit

    end

    def new
      @testimonial = Testimonial.new
    end

    def create
      @testimonial = Testimonial.new
      update_testimonial('created')
    end

    def update
      update_testimonial('updated')
    end

    def destroy
      @testimonial.destroy
      flash[:success] = "Testimonial deleted"
      redirect_to admin_testimonials_path
    end

    private

    def update_testimonial(action_name)
      if @testimonial.update_attributes testimonial_params
        flash[:success] = "testimonial #{action_name}"
        redirect_to admin_testimonials_path
      else
        flash[:error] = error_message
        render :edit, status: 400
      end
    end

    def error_message
      @testimonial.errors.messages.map do
        |key, value| "#{key} #{value.join(' and ')}"
      end.join(', ').capitalize + '.'
    end

    def find_testimonial
      @testimonial = Testimonial.find(params[:id] || params[:testimonial_id])
    end

    def testimonial_params
      params.require(:testimonial).permit(:text, :author, :food_partner_id)
    end

  end
end
