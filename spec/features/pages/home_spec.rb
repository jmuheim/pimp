require 'rails_helper'

describe 'Showing the home page' do
  before { visit root_path }

  it 'displays a welcome message' do
    expect(page).to have_breadcrumbs 'PIMP Editor', 'Welcome to PIMP Editor'
    expect(page).to have_headline 'Welcome to PIMP Editor'
  end
end
