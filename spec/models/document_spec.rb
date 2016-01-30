require 'rails_helper'

RSpec.describe Document, type: :model do
  it { should validate_presence_of(:name).with_message "can't be blank" }
  it { should have_many(:images).dependent :destroy }
  it { should accept_nested_attributes_for(:images).allow_destroy true }

  it 'has a valid factory' do
    expect(create :document).to be_valid
  end

  it 'provides optimistic locking' do
    document = create :document
    stale_document = Document.find(document.id)

    document.update_attribute :name, 'new name!'

    expect {
      stale_document.update_attribute :name, 'even newer name!'
    }.to raise_error ActiveRecord::StaleObjectError
  end

  describe 'versioning', versioning: true do
    it 'is versioned' do
      is_expected.to be_versioned
    end

    it 'versions name' do
      document = create :document

      expect {
        document.update_attributes! name: 'New name'
      }.to change { document.versions.count }.by 1
    end

    it 'versions description' do
      document = create :document

      expect {
        document.update_attributes! description: 'New description'
      }.to change { document.versions.count }.by 1
    end

    it 'versions content' do
      document = create :document

      expect {
        document.update_attributes! content: 'New content'
      }.to change { document.versions.count }.by 1
    end
  end

  describe 'image path placeholder replacement' do
    before do
      @document = create :document, name: 'My cool document',
                                    content: "This is a paragraph\n\n![This is an image](an-image)\n\n![This is another image](another-image)"

      @document.images << create(:image, identifier: 'an-image')
    end

    describe '#content_with_referenced_images' do
      subject { @document.content_with_referenced_images }

      it 'replaces image path placeholders with urls' do
        should include '![This is an image](/uploads/image/file/1/image.jpg)'
        should include '![This is another image](another-image)'
      end
    end

    describe '#content_with_embedded_images' do
      subject { @document.content_with_embedded_images }

      it 'replaces image path placeholders with paths' do
        should match /!\[This is an image\]\((.*)\/uploads\/image\/file\/1\/image.jpg\)/
        should include '![This is another image](another-image)'
      end
    end
  end
end
