require 'rails_helper'

RSpec.describe Image, type: :model do
  it { should belong_to(:document) }

  describe 'object file upload' do
    it 'should accept images (jpg, gif, png)'
    it 'should scale images (different versions!)'
  end
end
