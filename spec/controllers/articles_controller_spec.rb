# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe 'GET index' do
    VCR.use_cassette('s3_download_success') do
      it 'assigns @articles' do
        get :index
        expect(assigns(:articles).count).to eq(25)
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template("index")
      end
    end
  end

  describe 'GET show' do
    VCR.use_cassette('s3_download_success') do
      it 'downloads articles' do
        get :show, params: { id: 3899631 }
        expect(Article.all.count).to eq(25)
      end

      it 'assigns @article' do
        get :show, params: { id: 3899631 }
        expect(assigns(:article)).to eq(Article.find(3899631))
      end

      it 'renders the show template' do
        get :show, params: { id: 3899631 }
        expect(response).to render_template("show")
      end
    end
  end
end
