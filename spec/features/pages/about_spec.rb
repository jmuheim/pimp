require 'rails_helper'

describe 'Showing about page' do
  before { visit page_path('about') }

  it 'displays the about page' do
    expect(page).to have_active_navigation_items 'About'
    expect(page).to have_breadcrumbs 'PIMP Editor', 'About PIMP Editor'
    expect(page).to have_headline 'About'
  end
end
