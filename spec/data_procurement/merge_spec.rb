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
      expect(sample['address'].strip).to eq hotel_c_samples.first['address'].strip
      expect(sample['city']).to eq hotel_a_samples.first['City'].strip
      expect(sample['country'].strip).to eq hotel_b_samples.first['location']['country'].strip
      expect(sample['postal_code'].strip).to eq hotel_a_samples.first['PostalCode'].strip
    end
  end

  context 'description' do
    let(:sample) { subject.first }

    it 'merges descriptions' do
      expect(sample['description'].strip).to include hotel_a_samples.first['Description'].strip
      expect(sample['description'].strip).to include hotel_b_samples.first['details'].strip
      expect(sample['description'].strip).to include hotel_c_samples.first['info'].strip
    end
  end

  context 'amenities' do
    let(:sample) { subject.first }

    it 'merges amenites' do
      expect(sample['amenities']).to eq(
        [
          hotel_a_samples.first['Facilities'],
          hotel_b_samples.first['amenities']['general'],
          hotel_b_samples.first['amenities']['room'],
          hotel_c_samples.first['amenities']
        ].flatten.compact.uniq
      )
    end
  end

  context 'images' do
    let(:sample) { subject.first }
    let(:expectation) do
      [
        {"url"=>"https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg", "caption"=>"Double room"},
        {"url"=>"https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/3.jpg", "caption"=>"Double room"},
        {"url"=>"https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/1.jpg", "caption"=>"Front"},
        {"url"=>"https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/4.jpg", "caption"=>"Bathroom"},
        {"url"=>"https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/0.jpg", "caption"=>"RWS"},
        {"url"=>"https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/6.jpg", "caption"=>"Sentosa Gateway"}
      ]
    end

    it 'merges images' do
      expect(sample['images']).to eq(expectation)
    end
  end
end
