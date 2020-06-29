FactoryBot.define do
  factory :post do
    association :author
    content { Faker::Books::Lovecraft.sentence }
  end
end
