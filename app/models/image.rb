class Image < ActiveRecord::Base
  belongs_to :document

  mount_uploader :object, ImageUploader
end
