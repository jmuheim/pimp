require 'rails_helper'

describe 'Listing documents' do
  before do
    @document = create :document
    login_as(create :user)
  end

  it 'displays documents' do
    visit documents_path

    expect(page).to have_active_navigation_items 'Documents', 'List Documents'
    expect(page).to have_breadcrumbs 'Pimp', 'Documents'
    expect(page).to have_headline 'Documents'

    within dom_id_selector(@document) do
      expect(page).to have_css '.name a',      text: 'Document test name'
      expect(page).to have_css '.description', text: 'Document test description'

      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end

    expect(page).to have_link 'Create Document'
  end
end
