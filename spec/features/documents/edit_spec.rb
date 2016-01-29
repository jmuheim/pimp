require 'rails_helper'

describe 'Editing document' do
  before { login_as create :user }

  it 'grants permission to edit a document' do
    @document = create :document, :with_image
    visit edit_document_path(@document)

    expect(page).to have_active_navigation_items 'Documents'
    expect(page).to have_breadcrumbs 'PIMP Editor', 'Documents', 'Document test name', 'Edit'
    expect(page).to have_headline 'Edit Document test name'

    fill_in 'document_name',        with: 'A new name'
    fill_in 'document_description', with: 'Cooool description!'
    fill_in 'document_content',     with: 'Some nice content'

    attach_file 'document_images_attributes_0_file', dummy_file_path('other_image.jpg')

    expect {
      click_button 'Update Document'
      @document.reload
    } .to  change { @document.name }.to('A new name')
      .and change { @document.description }.to('Cooool description!')
      .and change { @document.content }.to('Some nice content')
      .and change { @document.images.first.file.file.identifier }.to('other_image.jpg')
  end

  it "prevents from overwriting other users' changes accidently (caused by race conditions)" do
    @document = create :document
    visit edit_document_path(@document)

    # Change something in the database...
    expect {
      @document.update_attributes name: 'This is the old name',
                                  description: 'First do this.\nThen do that.\nFinally, do the rest.'
    }.to change { @document.lock_version }.by 1

    fill_in 'document_name',        with: 'This is a new name, yeah!'
    fill_in 'document_description', with: 'First do that.\nAnd finally, do that.'

    expect {
      click_button 'Update Document'
      @document.reload
    }.not_to change { @document }

    expect(page).to have_flash('Document meanwhile has been changed. The conflicting fields are: Name and Description.').of_type :alert

    expect {
      click_button 'Update Document'
      @document.reload
    } .to  change { @document.name }.to('This is a new name, yeah!')
      .and change { @document.description }.to('First do that.\nAnd finally, do that.')
  end
end
