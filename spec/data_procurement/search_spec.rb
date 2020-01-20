require 'rails_helper'

describe DataProcurement::Search do
  let(:hotel_a_samples) do
    JSON.parse File.read(Rails.root.join('spec/fixtures/services/hotel_a.json'))
  end
  let(:hotel_b_samples) do
    JSON.parse File.read(Rails.root.join('spec/fixtures/services/hotel_b.json'))
  end
  let(:hotel_c_samples) do
    JSON.parse File.read(Rails.root.join('spec/fixtures/services/hotel_c.json'))
  end
  let(:segment_groups) { [hotel_a_samples, hotel_b_samples, hotel_c_samples] }
  let(:resource) { DataProcurement::Merge.new.merge(segment_groups: segment_groups) }

  subject do
    DataProcurement::Search.search(
      resource: resource,
      filter: params
    )
  end

  context 'searches by hotel_id' do
    let(:params) do
      { id: 'iJhz' }
    end

    it 'returns 1' do
      expect(subject.size).to eq 1
    end
  end

  context 'searches by destination_id' do
    let(:params) do
      { destination_id: '5432' }
    end

    it 'returns 2' do
      expect(subject.size).to eq 2
    end
  end

  context 'searches by hotel_id and destination_id' do
    let(:params) do
      { destination_id: '5432', id: 'iJhz' }
    end

    it 'returns 1' do
      expect(subject.size).to eq 1
    end
  end

  context 'invalid searches' do
    let(:params) do
      { id: 'cant-be-found' }
    end

    it 'return nothing' do
      expect(subject).to be_empty
    end
  end
end
