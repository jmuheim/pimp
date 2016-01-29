FactoryGirl.define do
  factory :image do
    file { File.open dummy_file_path('image.jpg') }
  end
end
