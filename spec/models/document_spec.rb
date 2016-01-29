require 'rails_helper'

RSpec.describe Document, type: :model do
  it { should validate_presence_of(:name).with_message "can't be blank" }
  it { should have_many(:images) }

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
end
