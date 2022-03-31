# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Endpoint, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:verb) }
    it do
      should validate_inclusion_of(:verb)
        .in_array(%w[GET HEAD POST PUT DELETE CONNECT OPTIONS TRACE])
        .with_message('shoulda-matchers test string is not a valid HTTP verb')
    end

    it { should validate_presence_of(:path) }

    it { should validate_presence_of(:response) }
  end
end
