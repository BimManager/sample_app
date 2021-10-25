FactoryBot.define do
  factory :user do
    name { 'Michael Hartl' }
    email { 'michaelhartl@example.com' }
    password { 'foobar' }
    password_confirmation { 'foobar' }
  end
end