class S3DownloadService
  attr_reader :bucket, :key, :modification_date

  def initialize(opts)
    @bucket = opts[:bucket]
    @key = opts[:key]
    @modification_date = opts[:modification_date]
  end

  def download
    s3 = Aws::S3::Client.new
    resp = s3.get_object(bucket: bucket, key: key, if_modified_since: modification_date)
    resp
  end
end