# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Endpoints', type: :request do
  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates and returns the endpoint object' do
        raw_body = {
          data: {
            type: 'endpoints',
            attributes: {
              verb: 'GET',
              path: '/greeting',
              response: {
                code: 200,
                headers: {},
                body: '"{ "message": "Hello, world" }"'
              }
            }
          }
        }

        post '/endpoints', params: raw_body

        expect(response.status).to eq(201)
        json = JSON.parse(response.body)['data']
        expect(json['type']).to eq('endpoints')
        expect(json['id']).to eq('1')
        expect(json['attributes']['verb']).to eq('GET')
        expect(json['attributes']['path']).to eq('/greeting')
        expect(json['attributes']['response']['code']).to eq('200')
        expect(json['attributes']['response']['body']).to eq('"{ "message": "Hello, world" }"')
      end
    end

    context 'with invalid parameters' do
      it 'returns error' do
        raw_body = {
          data: {
            type: 'endpoints',
            attributes: {
              verb: 'GETTT',
              path: '/greeting/',
              response: {
                code: 200
              }
            }
          }
        }

        post '/endpoints', params: raw_body

        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        expect(json['errors'][0]['code']).to eq('unprocessable_entity')
        expect(json['errors'][0]['detail']['verb']).to eq(['GETTT is not a valid HTTP verb'])
        expect(json['errors'][0]['detail']['path']).to eq(['is invalid'])
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

        create(:endpoint, verb: 'GET', path: '/greeting', response: { code: 200 })

        post '/endpoints', params: raw_body

        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        expect(json['errors'][0]['code']).to eq('duplicate_entry')
        expect(json['errors'][0]['detail']).to eq('Same verb and path is already used in the server')
      end
    end
  end
end
