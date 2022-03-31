# frozen_string_literal: true

class EndpointsController < ApplicationController
  before_action :set_headers

  def create
    @endpoint = Endpoint.new(endpoint_params['attributes'])
    if @endpoint.save
      render json: prepare_endpoint_json, status: :created
    else
      render json: { errors: [{ code: 'unprocessable_entity', detail: @endpoint.errors }] },
             status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    render json: { errors: [{ code: 'duplicate_entry', detail: 'Same verb and path is already used in the server' }] },
           status: :unprocessable_entity
  rescue StandardError => e
    render json: { errors: [{ code: 'internal_error', detail: e }] }, status: :internal_server_error
  end

  private

  def set_headers
    response.headers['Content-Type'] = 'application/vnd.api+json'
  end

  def prepare_endpoint_json
    { data: { type: 'endpoints', id: @endpoint.id,
              attributes: { verb: @endpoint.verb, path: @endpoint.path, response: @endpoint.response } } }
  end

  def endpoint_params
    params.require(:data).permit(:type, attributes: [:verb, :path, { response: [:code, :body, { headers: {} }] }])
  end
end
