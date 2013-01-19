FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "foo#{n}@example.com" }
    password "google123"
    password_confirmation { |u| u.password }
  end
end