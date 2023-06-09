# frozen_string_literal: true

require 'rails_helper'

RSpec.describe S3DownloadService, :vcr do
  let(:success_params) do
    {
      bucket: ENV['AWS_BUCKET_NAME'],
      key: ENV['AWS_OBJECT_NAME']
    }
  end

  let(:not_modified_params) do
    {
      bucket: ENV['AWS_BUCKET_NAME'],
      key: ENV['AWS_OBJECT_NAME'],
      modification_date: Time.new(2023, 5, 31, 0, 0, 0, +1)
    }
  end

  let(:invalid_params) do
    {
      bucket: ENV['AWS_BUCKET_NAME'],
      key: 'does_not_exist'
    }
  end

  let(:success_body) { file_fixture('s3_download_response.json').read }

  describe '.download' do
    it 'returns successfully' do
      VCR.use_cassette('s3_download_success') do
        response = described_class.new(success_params).download
        expect(response).to eq(success_body)
      end
    end

    it 'returns an empty JSON list if file has not been modified' do
      VCR.use_cassette('s3_download_not_modified') do
        expect(described_class.new(not_modified_params).download).to eq('[]')
      end
    end

    it 'returns an empty JSON list if file does not exist' do
      VCR.use_cassette('s3_download_invalid') do
        expect(described_class.new(invalid_params).download).to eq('[]')
      end
    end
  end
end
