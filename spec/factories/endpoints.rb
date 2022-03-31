# frozen_string_literal: true

FactoryBot.define do
  factory :endpoint do
    id { '12345' }
    verb { 'GET' }
    path { '/something' }
    response { { code: 200, body: 'something' } }
  end
end
