#require 'rails_helper'
#
#module Admin
#  describe PollsController do
#    describe '#index' do
#      let(:make_request) { get :index }
#
#      
#      it_behaves_like 'requires admin authentication'
#
#      context 'authenticated' do
#        before do
#          create(:poll)
#          allow_any_instance_of(PollsController)
#            .to receive(:require_admin_authentication)
#          request.env['HTTPS'] = 'on'
#          make_request
#        end
#
#        it_behaves_like 'OK response'
#
#        it 'renders the index template' do
#          expect(response).to have_rendered('index')
#        end
#
#        it 'gets all the polls' do
#          expect(assigns[:polls]).not_to be_nil
#        end
#      end
#    end
#
#    describe '#new' do
#      let(:make_request) { get :new }
#
#      
#      it_behaves_like 'requires admin authentication'
#
#      context 'authenticated' do
#        before do
#          allow_any_instance_of(PollsController)
#            .to receive(:require_admin_authentication)
#          request.env['HTTPS'] = 'on'
#          make_request
#        end
#
#        it_behaves_like 'OK response'
#
#        it 'renders the new template' do
#          expect(response).to have_rendered('new')
#        end
#
#        it 'assigns a new poll to the poll instance variable' do
#          expect(assigns[:poll]).not_to be_nil
#        end
#      end
#    end
#
#    describe '#create' do
#      let(:params) do
#        {
#          poll: {
#            title: 'a poll',
#            description_html: 'something',
#            answers: [
#              {
#                order: 1,
#                answer_text: 'yes'
#              },
#              {
#                order: 2,
#                answer_text: 'no'
#              }
#            ]
#          }
#        }
#      end
#      let(:make_request) { post :create, params }
#      let(:poll) { Poll.all.first }
#
#      it_behaves_like 'redirects with no ssl'
#      it_behaves_like 'redirects when not authenticated'
#
#      context 'authenticated' do
#        before do
#          allow_any_instance_of(PollsController)
#            .to receive(:require_admin_authentication)
#          request.env['HTTPS'] = 'on'
#          make_request
#        end
#
#        it 'creates a new poll' do
#          expect(poll).not_to be_nil
#        end
#
#        it 'sets the title' do
#          expect(poll.title).to eq 'a poll'
#        end
#
#        it 'sets the description' do
#          expect(poll.description_html).to eq 'something'
#        end
#
#        it 'creates the answers' do
#          expect(poll.poll_answers.size).to eq 2
#        end
#
#        it 'redirects to the edit page' do
#          expect(response).to redirect_to edit_admin_poll_path(poll.id)
#        end
#
#        it 'sets a flash message' do
#          expect(flash[:success]).to eq 'Poll created'
#        end
#      end
#    end
#
#    describe '#edit' do
#      let(:make_request) { get :edit, id: poll.id }
#      let(:poll) { create(:poll_with_answers) }
#
#      
#      it_behaves_like 'requires admin authentication'
#
#      context 'authenticated' do
#        before do
#          allow_any_instance_of(PollsController)
#            .to receive(:require_admin_authentication)
#          request.env['HTTPS'] = 'on'
#          make_request
#        end
#
#        it_behaves_like 'OK response'
#
#        it 'renders the edit template' do
#          expect(response).to have_rendered('edit')
#        end
#
#        it 'assigns the poll to the poll instance variable' do
#          expect(assigns[:poll]).to eq poll
#        end
#
#        it 'assigns the poll answers to an instance variable' do
#          expect(assigns[:poll_answers]).to eq poll.poll_answers
#        end
#      end
#    end
#
#    describe '#update' do
#      let(:poll) { create(:poll_with_answers) }
#      let(:poll_answer) { poll.poll_answers[0] }
#
#      let(:params) do
#        {
#          id: poll.id,
#          poll: {
#            title: 'new poll title',
#            description_html: 'something else nice and new',
#            answers: [
#              {
#                id: poll_answer.id,
#                order: 1,
#                answer_text: 'maybe'
#              },
#              {
#                order: 2,
#                answer_text: 'no'
#              }
#            ]
#          }
#        }
#      end
#      let(:make_request) { post :update, params }
#
#      it_behaves_like 'redirects with no ssl'
#      it_behaves_like 'redirects when not authenticated'
#
#      context 'authenticated' do
#        before do
#          allow_any_instance_of(PollsController)
#            .to receive(:require_admin_authentication)
#          request.env['HTTPS'] = 'on'
#          make_request
#          poll.reload
#          poll_answer.reload
#        end
#
#        it 'redirects to the edit page' do
#          expect(response).to redirect_to edit_admin_poll_path(poll.id)
#        end
#
#        it 'sets a flash message' do
#          expect(flash[:success]).to eq 'Poll details updated'
#        end
#
#        it 'updates the title' do
#          expect(poll.title).to eq 'new poll title'
#        end
#
#        it 'updates the description html' do
#          expect(poll.description_html).to eq 'something else nice and new'
#        end
#
#        it 'updates the existing answers' do
#          expect(poll_answer.answer_text).to eq 'maybe'
#        end
#
#        it 'adds new answers' do
#          expect(poll.poll_answers.size).to eq 2
#        end
#      end
#    end
#  end
#end
