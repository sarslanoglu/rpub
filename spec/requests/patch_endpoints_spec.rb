# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Endpoints', type: :request do
  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'updates and returns the endpoint object' do
        raw_body = {
          data: {
            type: 'endpoints',
            attributes: {
              verb: 'POST',
              path: '/testing_welcome',
              response: {
                code: 200,
                body: '"{ "message": "Hello, world" }"'
              }
            }
          }
        }

        endpoint = create(:endpoint, verb: 'GET', path: '/testing_greeting', response: { code: 200 })

        expect(endpoint['id']).to eq('1')
        expect(endpoint['verb']).to eq('GET')
        expect(endpoint['path']).to eq('/testing_greeting')

        patch "/endpoints/#{endpoint.id}", params: raw_body

        expect(response.status).to eq(200)
        json = JSON.parse(response.body)['data']
        expect(json['id']).to eq('1')
        expect(json['attributes']['verb']).to eq('POST')
        expect(json['attributes']['path']).to eq('/testing_welcome')
        expect(json['attributes']['response']['code']).to eq('200')
        expect(json['attributes']['response']['body']).to eq('"{ "message": "Hello, world" }"')
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity error' do
        raw_body = {
          data: {
            type: 'endpoints',
            attributes: {
              verb: 'POSTY',
              path: '/testing_welcome',
              response: {
                code: 200
              }
            }
          }
        }

        endpoint = create(:endpoint, verb: 'GET', path: '/testing_greeting', response: { code: 200 })

        expect(endpoint['id']).to eq('1')
        expect(endpoint['verb']).to eq('GET')
        expect(endpoint['path']).to eq('/testing_greeting')

        patch "/endpoints/#{endpoint.id}", params: raw_body

        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        expect(json['errors'][0]['code']).to eq('unprocessable_entity')
        expect(json['errors'][0]['detail']['verb']).to eq(['POSTY is not a valid HTTP verb'])
      end

      it 'returns not found error' do
        raw_body = {
          data: {
            type: 'endpoints',
            attributes: {
              verb: 'POST',
              path: '/testing_welcome',
              response: {
                code: 200
              }
            }
          }
        }

        endpoint = create(:endpoint, verb: 'GET', path: '/testing_greeting', response: { code: 200 })

        expect(endpoint['id']).to eq('1')
        expect(endpoint['verb']).to eq('GET')
        expect(endpoint['path']).to eq('/testing_greeting')

        patch "/endpoints/#{endpoint.id.to_i + 1}", params: raw_body

        expect(response.status).to eq(404)
        json = JSON.parse(response.body)
        expect(json['errors'][0]['code']).to eq('not_found')
        expect(json['errors'][0]['detail']).to eq('Requested Endpoint with ID `2` does not exist')
      end
    end

    context 'with dublicate entry' do
      it 'returns meaningful error' do
        raw_body = {
          data: {
            type: 'endpoints',
            attributes: {
              verb: 'GET',
              path: '/greeting',
              response: {
                code: 200
              }
            }
          }
        }

        endpoint_one = create(:endpoint, verb: 'GET', path: '/greeting', response: { code: 200 })
        endpoint_two = create(:endpoint, verb: 'POST', path: '/greeting', response: { code: 200 })

        expect(endpoint_one['id']).to eq('1')
        expect(endpoint_one['verb']).to eq('GET')
        expect(endpoint_one['path']).to eq('/greeting')
        expect(endpoint_two['id']).to eq('2')
        expect(endpoint_two['verb']).to eq('POST')
        expect(endpoint_two['path']).to eq('/greeting')

        patch "/endpoints/#{endpoint_two.id}", params: raw_body

        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        expect(json['errors'][0]['code']).to eq('duplicate_entry')
        expect(json['errors'][0]['detail']).to eq('Same verb and path is already used in the server')
      end
    end
  end
end
