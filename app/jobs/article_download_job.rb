# frozen_string_literal: true

class ArticleDownloadJob
  attr_reader :downloader

  def initialize(opts = {})
    config = opts[:config] || {}
    @downloader ||= opts[:downloader] || S3DownloadService.new(config)
  end

  def run
    begin
      response = downloader.download
      articles = parse(response)
      update_articles(articles)
    rescue Aws::S3::Errors::NotModified
      puts 'File not modified'
    rescue Aws::S3::Errors::AccessDenied
      puts 'Access Denied, object may not exist'
    end
  end

  private

  def parse(response)
    JSON.parse(response.body.read)
  end

  def update_articles(articles)
    stored_articles = Article.all
    articles.each do |article|
      stored_article = stored_articles.find { |item| item.id == article['id'] }
      if stored_article && stored_article.updated_at < article['updated_at']
        stored_article.update(
          title: article['title'],
          description: article['description'],
          section: article['section'],
          created_at: article['created_at'],
          updated_at: article['updated_at']
        )
      elsif !stored_article
        Article.create(
          id: article['id'],
          title: article['title'],
          description: article['description'],
          section: article['section'],
          created_at: article['created_at'],
          updated_at: article['updated_at']
        )
      end
    end
  end
end
