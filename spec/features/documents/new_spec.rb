require 'rails_helper'

describe 'Creating document' do
  before { login_as create :user }

  it 'creates a document', js: true do
    visit new_document_path

    expect(page).to have_active_navigation_items 'Documents', 'Create Document'
    expect(page).to have_breadcrumbs 'PIMP Editor', 'Documents', 'Create Document'
    expect(page).to have_headline 'Create Document'

    fill_in 'document_name',        with: 'newname'
    fill_in 'document_description', with: 'newdescription'
    fill_in 'document_content',     with: 'newcontent'

    expect {
      click_link 'Add image'
    } .to change { all('#images .nested-fields').count }.by 1

    file_field_id = page.find('#images .nested-fields [id^="document_images_attributes_"][id$="_file"]')[:id] # Ugly
    new_nested_fields_id = file_field_id.match(/^document_images_attributes_(\d+)_file$/)[1]
    fill_in file_field_id, with: base64_image[:data]
    fill_in "document_images_attributes_#{new_nested_fields_id}_identifier", with: 'some-identifier'

    expect {
      click_button 'Create Document'
    }.to change { Document.count }.by(1)
    .and change { Image.count }.by 1

    expect(page).to have_flash 'Document was successfully created.'
  end
end
