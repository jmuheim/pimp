class Image < ActiveRecord::Base
  belongs_to :document

  mount_base64_uploader :file, ImageUploader
end
