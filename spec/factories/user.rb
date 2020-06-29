FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    email { Faker::Internet.email }
    password { "Hello World" }
    password_confirmation { "Hello World" }

    factory :user_with_a_friend do
      after(:create) do |user|
        another_user = create(:user)
        user.friends << another_user
        another_user.friends << user
      end
    end
  end
end
