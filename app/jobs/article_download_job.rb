# frozen_string_literal: true

class ArticleDownloadJob
  attr_reader :downloader

  def initialize(opts = {})
    config = opts[:config] || {}
    @downloader ||= opts[:downloader] || S3DownloadService.new(config)
  end

  def perform
    response = downloader.download
    articles = parse(response)
    update_articles(articles)
  end

  private

  def parse(response)
    JSON.parse(response)
  end

  def update_articles(articles)
    stored_articles = Article.all
    articles.each do |article|
      stored_article = stored_articles.find { |item| item.id == article['id'] }
      if process_article?(article, stored_article)
        Article.upsert(article_map(article))
      end
    end
  end

  def process_article?(article, stored_article)
    !stored_article || (stored_article && stored_article.updated_at < article['updated_at'])
  end

  def article_map(article)
    {
      id: article['id'],
      title: article['title'],
      description: article['description'],
      section: article['section'],
      created_at: article['created_at'],
      updated_at: article['updated_at']
    }
  end
end
