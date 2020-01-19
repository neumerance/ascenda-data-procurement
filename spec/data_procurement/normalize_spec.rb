require 'rails_helper'

describe DataProcurement::Normalize do
  let(:hotel_a_samples) do
    JSON.parse File.read(Rails.root.join('spec/fixtures/services/hotel_a.json'))
  end
  let(:hotel_b_samples) do
    JSON.parse File.read(Rails.root.join('spec/fixtures/services/hotel_b.json'))
  end

  describe 'normalizing API response from hotel_a' do
    subject { described_class.normalize(segment: hotel_a_samples.first) }

    let(:expectation) do
      {
        'id' => hotel_a_samples.first['Id'],
        'destination_id' => hotel_a_samples.first['DestinationId'],
        'name' => hotel_a_samples.first['Name'],
        'lat' => hotel_a_samples.first['Latitude'],
        'lng' => hotel_a_samples.first['Longitude'],
        'address' => hotel_a_samples.first['Address'],
        'city' => hotel_a_samples.first['City'],
        'country' => hotel_a_samples.first['Country'],
        'postal_code' => hotel_a_samples.first['PostalCode'],
        'description' => hotel_a_samples.first['Description'],
        'amenities' => hotel_a_samples.first['Facilities']
      }
    end

    it { is_expected.to eq expectation }
  end

  describe 'normalizing API response from hotel_c' do
    subject { described_class.normalize(segment: hotel_b_samples.first) }

    let(:expectation) do
      {
        'id' => hotel_b_samples.first['hotel_id'],
        'destination_id' => hotel_b_samples.first['destination_id'],
        'name' => hotel_b_samples.first['hotel_name'],
        'address' => hotel_b_samples.first['location']['address'],
        'country' => hotel_b_samples.first['location']['country'],
        'description' => hotel_b_samples.first['details'],
        'amenities' => hotel_b_samples.first['amenities']['general'] +
                       hotel_b_samples.first['amenities']['room'],
        'images' => [
          {
            "url" => "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg",
            "caption" => "Double room"
          },
          {
            "url" => "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/3.jpg",
            "caption" => "Double room"
          },
          {
            "url" => "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/1.jpg",
            "caption" => "Front"
          }
        ],
        'booking_conditions' => hotel_b_samples.first['booking_conditions']
      }
    end

    it { is_expected.to eq expectation }
  end
end
