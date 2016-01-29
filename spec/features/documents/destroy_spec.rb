require 'rails_helper'

describe 'Deleting report' do
  before do
    @document = create :document
    login_as(create :user)
  end

  it 'deletes a document' do
    expect {
      visit_delete_path_for(@document)
    }.to change { Document.count }.by -1
  end
end
