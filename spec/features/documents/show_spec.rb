require 'rails_helper'

describe 'Showing document' do
  before { login_as(create :user, name: 'Donald Duck') }

  it 'displays a document' do
    @document = create :document, :with_image
    visit document_path(@document)

    expect(page).to have_active_navigation_items 'Documents'
    expect(page).to have_breadcrumbs 'PIMP Editor', 'Documents', 'Document test name'
    expect(page).to have_headline 'Document test name'

    within dom_id_selector(@document) do
      expect(page).to have_css '.description', text: 'Document test description'
      expect(page).to have_css '.content',     text: 'Document test content'
      expect(page).to have_css '.images a img'
      expect(page).to have_css '.created_at',  text: 'Mon, 15 Jun 2015 14:33:52 +0200'
      expect(page).to have_css '.updated_at',  text: 'Mon, 15 Jun 2015 14:33:52 +0200'

      expect(page).to have_link 'Preview as HTML'
      expect(page).to have_link 'Export to Docx'
      expect(page).to have_link 'Export to Odt'
      expect(page).to have_link 'Export to Epub'

      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end
  end

  describe 'export' do
    before do
      @document = create :document, name: 'My cool document',
                                    content: "# This is h1\n\nThis is a paragraph\n\n![This is an image](an-image)"

      @document.images << create(:image, identifier: 'an-image')
    end

    it 'previews a document as HTML' do
      visit document_path(@document, standalone: true)

      within '#header:nth-child(1)' do
        expect(page).to have_css 'h1.title:nth-child(1)', text: 'My cool document'
        expect(page).to have_css 'h2.author:nth-child(2)', text: 'Donald Duck'
        expect(page).to have_css 'h3.date:nth-child(3)', text: 'Mon, 15 Jun 2015 12:33:52 +0000'
      end

      expect(page).to have_css 'h1#this-is-h1:nth-child(2)', text: 'This is h1'
      expect(page).to have_css 'p:nth-child(3)', text: 'This is a paragraph'

      within 'div.figure:nth-child(4)' do
        expect(page).to have_css 'img:nth-child(1)[alt="This is an image"][src="/uploads/image/file/1/image.jpg"]'
        expect(page).to have_css 'p.caption:nth-child(2)', text: 'This is an image'
      end
    end

    it 'exports to docx' do
      visit document_path(@document, format: :docx)

      expect(response_headers['Content-Disposition']).to eq 'attachment; filename="My cool document (2015-06-15 12-33).docx"'
      expect(response_headers['Content-Type']).to eq 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    end

    it 'exports to odt' do
      visit document_path(@document, format: :odt)

      expect(response_headers['Content-Disposition']).to eq 'attachment; filename="My cool document (2015-06-15 12-33).odt"'
      expect(response_headers['Content-Type']).to eq 'application/vnd.oasis.opendocument.text'
    end

    it 'exports to epub' do
      visit document_path(@document, format: :epub)

      expect(response_headers['Content-Disposition']).to eq 'attachment; filename="My cool document (2015-06-15 12-33).epub"'
      expect(response_headers['Content-Type']).to eq 'application/epub+zip'
    end
  end
end
