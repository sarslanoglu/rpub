# frozen_string_literal: true

class Endpoint < ApplicationRecord
  HTTP_VERBS = %w[GET HEAD POST PUT DELETE CONNECT OPTIONS TRACE].freeze
  RESPONSE_JSON_SCHEMA = Rails.root.join('config', 'schemas', 'response.json')

  validates :id, presence: true, uniqueness: { case_sensitive: false }
  validates :verb, presence: true, inclusion: { in: HTTP_VERBS, message: '%<value>s is not a valid HTTP verb' }
  validates :path, presence: true, format: { with: %r{/[a-zA-Z0-9_/-]*[^/]\z} }
  validates :response, presence: true, json: { schema: RESPONSE_JSON_SCHEMA }
end
