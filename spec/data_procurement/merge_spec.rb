require 'rails_helper'

describe DataProcurement::Merge do
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

  subject { described_class.new.merge(segment_groups: segment_groups) }

  context 'hotel_id' do
    let(:ids) {  subject.map { |x| x['id'] } }

    it 'should not be duplicated' do
      expect(ids.size).to eq ids.uniq.size
    end
  end

  context 'address' do
    let(:sample) { subject.first }

    it 'includes complete address info' do
      expect(sample['address']).to eq hotel_a_samples.first['Address']
      expect(sample['city']).to eq hotel_a_samples.first['City']
      expect(sample['country']).to eq hotel_b_samples.first['location']['country']
      expect(sample['postal_code']).eq hotel_a_samples.first['PostalCode']
    end
  end
end
