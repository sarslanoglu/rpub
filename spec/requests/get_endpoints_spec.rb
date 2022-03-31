# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Endpoints', type: :request do
  describe 'GET /index' do
    context 'with empty state' do
      it 'returns empty array' do
        get '/endpoints'
        expect(response).to have_http_status(:success)
        expect(json['data'].size).to eq(0)
      end
    end

    context 'with data inside' do
      before do
        FactoryBot.create_list(:endpoint, 10)
        get '/endpoints'
      end

      it 'returns all endpoints' do
        expect(response).to have_http_status(:success)
        expect(json['data'].size).to eq(10)
      end
    end
  end
end
