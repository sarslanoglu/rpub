# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Mocks', type: :request do
  describe '/mock' do
    context 'with valid parameters' do
      it 'returns the mock object' do
        # rubocop:disable Layout/LineLength
        create(:endpoint, verb: 'GET', path: '/greeting',
                          response: { code: 422, body: '"{ "message": "Hello, world" }"', headers: { header_key_one: 'header_value_one', header_key_two: 'header_value_two' } })
        # rubocop:enable Layout/LineLength

        get '/greeting'

        expect(response.status).to eq(422)
        expect(response.headers['header_key_one']).to eq('header_value_one')
        expect(response.headers['header_key_two']).to eq('header_value_two')
        json = JSON.parse(response.body)
        expect(json['message']).to eq('Hello, world')
      end
    end

    context 'with invalid parameters' do
      it 'returns error message' do
        create(:endpoint, verb: 'GET', path: '/greeting',
                          response: { code: 422, body: '"{ "message": "Hello, world" }"' })

        post '/greeting'

        expect(response.status).to eq(404)
        json = JSON.parse(response.body)
        expect(json['errors'][0]['code']).to eq('not_found')
        expect(json['errors'][0]['detail']).to eq('Requested page `/greeting` does not exist')
      end

      it 'returns error message with non existing' do
        post '/greeting/hello'

        expect(response.status).to eq(404)
        json = JSON.parse(response.body)
        expect(json['errors'][0]['code']).to eq('not_found')
        expect(json['errors'][0]['detail']).to eq('Requested page `/greeting/hello` does not exist')
      end
    end
  end
end
