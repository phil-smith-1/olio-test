# frozen_string_literal: true

class S3DownloadService
  attr_reader :bucket, :key, :modification_date

  def initialize(opts)
    @bucket = opts[:bucket] || ENV['AWS_BUCKET_NAME']
    @key = opts[:key] || ENV['AWS_OBJECT_NAME']
    @modification_date = opts[:modification_date]
  end

  def download
    s3 = Aws::S3::Client.new
    s3.get_object(bucket: bucket, key: key, if_modified_since: modification_date)
  end
end
