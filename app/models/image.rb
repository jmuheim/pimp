class Image < ActiveRecord::Base
  belongs_to :document

  mount_uploader :file, ImageUploader
end
