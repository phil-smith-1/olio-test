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
      modification_date: Time.new(2023, 05, 31, 0, 0, 0)
    }
  end

  let(:invalid_params) do
    {
      bucket: ENV['AWS_BUCKET_NAME'],
      key: 'does_not_exist'
    }
  end

  describe '.download' do
    it 'returns successfully' do
      VCR.use_cassette('s3_download_success') do
        response = described_class.new(success_params).download
        expect(response.body).to be_a(StringIO)
      end
    end

    it "raises not modified error if file has not been modified" do
      VCR.use_cassette('s3_download_not_modified') do
        expect{described_class.new(not_modified_params).download}.to raise_error(Aws::S3::Errors::NotModified)
      end
    end

    it "raises does not exist error if file has not been modified" do
      VCR.use_cassette('s3_download_invalid') do
        expect{described_class.new(invalid_params).download}.to raise_error(Aws::S3::Errors::AccessDenied)
      end
    end
  end
end