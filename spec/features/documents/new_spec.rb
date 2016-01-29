require 'rails_helper'

describe 'Creating document' do
  before { login_as create :user }

  it 'creates a document' do
    visit new_document_path
    expect(page).to have_active_navigation_items 'Documents', 'Create Document'
    expect(page).to have_breadcrumbs 'PIMP Editor', 'Documents', 'Create'
    expect(page).to have_headline 'Create Document'

    fill_in 'document_name',        with: 'newname'
    fill_in 'document_description', with: 'newdescription'
    fill_in 'document_content',     with: 'newcontent'

    click_button 'Create Document'

    expect(page).to have_flash 'Document was successfully created.'
  end
end
