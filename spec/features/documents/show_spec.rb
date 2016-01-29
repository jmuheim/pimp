require 'rails_helper'

describe 'Showing document' do
  before do
    @document = create :document
    login_as(create :admin)
  end

  it 'displays a document' do
    visit document_path(@document)

    expect(page).to have_active_navigation_items 'Documents'
    expect(page).to have_breadcrumbs 'Pimp', 'Documents', 'Document test name'
    expect(page).to have_headline 'Document test name'

    within dom_id_selector(@document) do
      expect(page).to have_css '.description', text: 'Document test description'
      expect(page).to have_css '.content',     text: 'Document test content'
      expect(page).to have_css '.created_at',  text: 'Mon, 15 Jun 2015 14:33:52 +0200'
      expect(page).to have_css '.updated_at',  text: 'Mon, 15 Jun 2015 14:33:52 +0200'

      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end
  end
end
