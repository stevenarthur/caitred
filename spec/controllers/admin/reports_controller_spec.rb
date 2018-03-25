require 'rails_helper'

module Admin
  describe ReportsController do
    describe '#index' do
      let(:make_request) { get :index }

      
      it_behaves_like 'requires admin authentication'

      context 'authenticated' do
        before do
          allow_any_instance_of(ReportsController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
        end

        it_behaves_like 'OK response'

        it 'renders the index template' do
          expect(response).to have_rendered('index')
        end
      end
    end

    describe '#completed_orders' do
      let(:make_request) { get :completed_orders }
      let!(:completed_enquiry) { create(:enquiry, status: EnquiryStatus::COMPLETED) }
      let!(:new_enquiry) { create(:enquiry, status: EnquiryStatus::NEW) }

      
      it_behaves_like 'requires admin authentication'

      context 'authenticated' do
        before do
          allow_any_instance_of(ReportsController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
        end

        it_behaves_like 'OK response'

        it 'renders the confirmcompleted_ordersed_orders template' do
          expect(response).to have_rendered('completed_orders')
        end

        it 'gets a list of the completed orders' do
          expect(assigns[:orders]).to include completed_enquiry
        end

        it 'does not include other orders' do
          expect(assigns[:orders]).not_to include new_enquiry
        end
      end
    end

    describe '#weekly' do
      let(:make_request) { get :weekly }

      
      it_behaves_like 'requires admin authentication'

      context 'authenticated' do
        before do
          t = Time.parse('25 November 2014') # Tuesday
          Timecop.travel(t)
          allow_any_instance_of(ReportsController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
        end

        it 'sets the start date to 12 weeks from the upcoming Sunday' do
          expect(assigns[:start_date].strftime('%d %b %y')).to eq '07 Sep 14'
        end

        it 'sets the end date to the end of last week' do
          expect(assigns[:end_date].strftime('%d %b %y')).to eq '30 Nov 14'
        end

        it 'displays data for each week in the last 12 weeks' do
          expect(assigns[:weekly_reports].size).to eq 12

        end
      end
    end

    describe '#monthly' do
      let(:make_request) { get :monthly }

      
      it_behaves_like 'requires admin authentication'

      context 'authenticated' do
        before do
          t = Time.parse('25 November 2014') # Tuesday
          Timecop.travel(t)
          allow_any_instance_of(ReportsController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
        end

        it 'sets the start date to 6 months ago' do
          expect(assigns[:start_date].strftime('%d %b %y')).to eq '01 Jun 14'
        end

        it 'sets the end date to today' do
          expect(assigns[:end_date].strftime('%d %b %y')).to eq '25 Nov 14'
        end

        it 'displays data for each month in the last 6' do
          expect(assigns[:monthly_reports].size).to eq 6
        end
      end
    end

    describe '#customers' do
      let(:make_request) { get :customers }

      
      it_behaves_like 'requires admin authentication'

      context 'authenticated' do
        before do
          t = Time.parse('25 November 2014') # Tuesday
          Timecop.travel(t)
          allow_any_instance_of(ReportsController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
        end

        it 'sets the customers report' do
          expect(assigns[:customer_reports]).not_to be_nil
        end
      end
    end
  end
end
