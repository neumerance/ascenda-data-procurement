require 'rails_helper'

describe FindHotelsController, type: :request do
  before do
    mock_hotel_service_apis
    get find_hotels_path, params: params
  end

  let(:json_response) do
    JSON.parse(response.body)
  end

  context 'searches by hotel_id' do
    let(:params) do
      { id: 'iJhz' }
    end

    it 'returns 1' do
      expect(json_response.size).to eq 1
    end
  end

  context 'searches by destination_id' do
    let(:params) do
      { destination_id: '5432' }
    end

    it 'returns 2' do
      expect(json_response.size).to eq 2
    end
  end

  context 'searches by hotel_id and destination_id' do
    let(:params) do
      { destination_id: '5432', id: 'iJhz' }
    end

    it 'returns 1' do
      expect(json_response.size).to eq 1
    end
  end

  context 'invalid searches' do
    let(:params) do
      { id: 'cant-be-found' }
    end

    it 'return nothing' do
      expect(json_response).to be_empty
    end
  end
end
