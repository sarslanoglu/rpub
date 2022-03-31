# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :endpoint do
    verb { 'GET' }
    path { "/something#{Faker::Number.number(digits: 10)}" }
    response { { code: 200, body: 'something' } }
  end
end
