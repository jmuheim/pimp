FactoryGirl.define do
  factory :image do
    object { File.open dummy_file_path('image.jpg') }
  end
end
