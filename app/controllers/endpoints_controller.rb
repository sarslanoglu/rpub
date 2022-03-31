# frozen_string_literal: true

class EndpointsController < ApplicationController
  before_action :set_headers
  before_action :find_endpoint, only: %i[update destroy]

  rescue_from StandardError do |_exception|
    render json: { errors: [{ code: 'internal_error', detail: 'Something went wrong. Please try again later' }] },
           status: :internal_server_error
  end

  def index
    @endpoints = Endpoint.all
    render json: prepare_list_endpoint_json
  end

  def create
    @endpoint = Endpoint.new(endpoint_params['attributes'])
    if @endpoint.save
      render json: prepare_single_endpoint_json, status: :created
    else
      render json: { errors: [{ code: 'unprocessable_entity', detail: @endpoint.errors }] },
             status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    render json: { errors: [{ code: 'duplicate_entry', detail: 'Same verb and path is already used in the server' }] },
           status: :unprocessable_entity
  end

  def update
    if @endpoint.update(endpoint_params['attributes'])
      render json: prepare_single_endpoint_json
    else
      render json: { errors: [{ code: 'unprocessable_entity', detail: @endpoint.errors }] },
             status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    render json: { errors: [{ code: 'duplicate_entry', detail: 'Same verb and path is already used in the server' }] },
           status: :unprocessable_entity
  end

  def destroy
    if @endpoint
      @endpoint.destroy
      render status: :no_content
    else
      render json: { errors: [{ code: 'internal_error', detail: 'Something went wrong. Please try again later.' }] },
             status: :internal_server_error
    end
  end

  private

  def set_headers
    response.headers['Content-Type'] = 'application/vnd.api+json'
  end

  def prepare_list_endpoint_json
    prepared_endpoints = []
    @endpoints.each do |endpoint|
      endpoint_object = { type: 'endpoints', id: endpoint.id,
                          attributes: { verb: endpoint.verb, path: endpoint.path, response: endpoint.response } }
      prepared_endpoints << endpoint_object
    end
    { data: prepared_endpoints }
  end

  def prepare_single_endpoint_json
    { data: { type: 'endpoints', id: @endpoint.id,
              attributes: { verb: @endpoint.verb, path: @endpoint.path, response: @endpoint.response } } }
  end

  def endpoint_params
    params.require(:data).permit(:type, attributes: [:verb, :path, { response: [:code, :body, { headers: {} }] }])
  end

  def find_endpoint
    @endpoint = Endpoint.find_by!(id: params['id'])
  rescue ActiveRecord::RecordNotFound
    error_detail = "Requested Endpoint with ID `#{params['id']}` does not exist"
    render json: { errors: [{ code: 'not_found', detail: error_detail }] },
           status: :not_found
  end
end
