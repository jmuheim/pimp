require 'rails_helper'

describe 'Creating document' do
  before { login_as create :user }

  it 'creates a document' do
    visit new_document_path

    # expect(page).to have_active_navigation_items 'Documents', 'Create Document'
    expect(page).to have_breadcrumbs 'PIMP Editor', 'Documents', 'Create Document'
    expect(page).to have_headline 'Create Document'

    fill_in 'document_name',        with: 'newname'
    fill_in 'document_description', with: 'newdescription'
    fill_in 'document_content',     with: 'newcontent'

    attach_file 'document_images_attributes_0_object', dummy_file_path('image.jpg')

    expect {
      click_button 'Create Document'
    }.to change { Document.count }.by(1)
    .and change { Image.count }.by 1

    expect(page).to have_flash 'Document was successfully created.'
  end

  it 'allows to add an image', js: true do
    visit new_document_path

    expect {
      click_link 'Add image'
    } .to change { all('#images .nested-fields').count }.by 1
  end
end
