require 'rails_helper'

RSpec.describe "documents/show", type: :view do
  it "Doesn't render empty description" do
    assign :document, create(:document, description: nil)
    render
    expect(rendered).not_to have_selector('.description')
  end

  it "Doesn't render empty content" do
    assign :document, create(:document, content: nil)
    render
    expect(rendered).not_to have_selector('.content')
  end

  it "Doesn't render empty images" do
    assign :document, create(:document, images: [])
    render
    expect(rendered).not_to have_selector('.images')
  end
end
