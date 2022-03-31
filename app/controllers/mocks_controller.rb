# frozen_string_literal: true

class MocksController < ApplicationController
  def mock
    http_verb = request.request_method
    path = "/#{params['path']}"

    endpoint = Endpoint.where(verb: http_verb).where(path:)

    if endpoint.empty?
      error_detail = "Requested page `#{path}` does not exist"
      render json: { errors: [{ code: 'not_found', detail: error_detail }] },
             status: :not_found
    else
      # Small trick to make return message more beautiful
      body = endpoint[0]['response']['body'][1...-1]
      endpoint[0]['response']['headers']&.each do |key, value|
        response.set_header(key, value)
      end
      render json: body, status: endpoint[0]['response']['code']
    end
  end
end
