class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show]
  before_action :download_articles, only: %i[index show]

  # GET /articles or /articles.json
  def index
    @articles = Article.all.order(updated_at: :desc)
    flash.notice = 'No articles found' unless @articles.count
  end

  # GET /articles/1 or /articles/1.json
  def show
  end

  # PUT /article/1/like
  def like
    @article = Article.find(params[:id])
    @article.increment!(:likes)
    redirect_to article_path(@article)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def article_params
    params.require(:article).permit(:title, :description, :section)
  end

  def download_articles
    last_modification = Article.maximum(:updated_at)
    downloader = S3DownloadService.new(
      bucket: ENV['AWS_BUCKET_NAME'],
      key: ENV['AWS_OBJECT_NAME'],
      modification_date: last_modification
    )
    ArticleDownloadJob.new(downloader: downloader).run
  end
end
