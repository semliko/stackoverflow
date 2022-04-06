require 'rails_helper'

RSpec.describe AttachedFilesController, type: :controller do

  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }
  let(:question) { create(:question, user: user_1) }

  describe 'DELETE #delete_attached_file' do
    context 'as an author of the file' do
      before do
        login(user_1)
      end
      let!(:file_1){ fixture_file_upload "#{Rails.root}/spec/rails_helper.rb" }
      let!(:answer) { create(:answer, question: question, user: user_1, files: [file_1]) }
      it 'deletes the answer' do
        file = answer.files.first
        #expect { delete :attached_file, params: { id: file.id } }.to change(answer.files, :count).by(-1)
        expect { patch :destroy, params: { id: file.id } }.to change(answer.files, :count).by(-1)
      end
    end
  end

  describe 'DELETE #delete_attached_file' do
    context 'as NOT an author of the file' do
      before do
        login(user_1)
      end
      let!(:file_1){ fixture_file_upload "#{Rails.root}/spec/rails_helper.rb" }
      let!(:answer) { create(:answer, question: question, user: user_1, files: [file_1]) }
      it 'cannot delete the answer' do
        sign_out(user_1)
        login(user_2)
        file = answer.files.first
        expect { patch :destroy, params: { id: file.id } }.to change(answer.files, :count).by(0)
      end
    end
  end
end
