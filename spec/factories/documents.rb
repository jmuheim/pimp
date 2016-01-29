FactoryGirl.define do
  factory :document do
    name        'Document test name'
    description 'Document test description'
    content     'Document test content'

    trait :with_image do
      images { [create(:image)] }
    end
  end
end
