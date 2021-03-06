FactoryBot.define do
  factory :user do
    name { 'Michael Hartl' }
    email { 'michaelhartl@example.com' }
    password { 'foobar' }
    password_confirmation { 'foobar' }
  end

  sequence(:email) do |n|
    "person-#{n}@example.com"
  end

  factory :micropost do
    content { 'Foo bar' }
    association :user
  end
end
