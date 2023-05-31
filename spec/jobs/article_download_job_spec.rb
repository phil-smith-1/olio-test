# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArticleDownloadJob do
  let(:downloader_double) { instance_double(S3DownloadService) }
  let(:downloader_response) do
    OpenStruct.new(
      {
        body:
          StringIO.new(
            '[
              {
                 "id":3899631,
                 "title":"Ambipur air freshener plugin",
                 "description":"Device only but refills are available most places",
                 "donation_description":"",
                 "collection":{
                    "id":0
                 },
                 "section":"product",
                 "location":{
                    "latitude":51.7645,
                    "longitude":-3.79131,
                    "distance":0,
                    "town":"Ystalyfera",
                    "country":"United Kingdom"
                 },
                 "collection_notes":"Any time!",
                 "value":{
                    "price":0,
                    "currency":"USD",
                    "payment_type":"no_payment_type"
                 },
                 "created_at":"2020-12-12T10:49:18.000Z",
                 "updated_at":"2020-12-12T10:49:18.000Z"
              },
              {
                 "id":3899634,
                 "title":"Epson Stylus Printer Cartridges",
                 "description":"7 X T0714 (yellow)\n4 X T0711 (black)\n1 X E712 (cyan)\n4 X E713 / T0713 (magenta)\n\n",
                 "donation_description":"",
                 "collection":{
                    "id":0
                 },
                 "section":"product",
                 "location":{
                    "latitude":51.764465,
                    "longitude":-3.791336,
                    "distance":0,
                    "town":"Ystalyfera",
                    "country":"United Kingdom"
                 },
                 "collection_notes":"Any time",
                 "value":{
                    "price":0,
                    "currency":"USD",
                    "payment_type":"no_payment_type"
                 },
                 "created_at":"2020-12-12T10:49:31.000Z",
                 "updated_at":"2020-12-12T10:49:58.000Z"
              }
           ]'
          )
      }
    )
  end

  before(:each) do
    allow(S3DownloadService).to receive(:new).and_return(downloader_double)
    allow(downloader_double).to receive(:download).and_return(downloader_response)
  end

  after(:all) do
    Article.delete_all
  end

  describe '.run' do
    describe 'when the articles do not exist' do
      it 'creates new Articles' do
        expect { described_class.new.run }.to change { Article.count }.by(2)
      end
    end

    describe 'when the articles exist' do
      it 'does not create new Articles' do
        expect { described_class.new.run }.to change { Article.count }.by(0)
      end
    end

    describe 'when an article is out of date' do
      let (:article) { Article.first }
      before do
        article.update(updated_at: Time.new(2017, 4, 15, 0, 0, 0, 0))
        described_class.new.run
      end

      it 'updates the article' do
        expect(Article.first.updated_at).to eq(Time.new(2020, 12, 12, 10, 49, 18, 0))
      end
    end

    describe 'When the data has not been modified' do
      before do
        allow(downloader_double).to receive(:download).and_raise(Aws::S3::Errors::NotModified.new({}, {}))
        Article.delete_all
      end

      it 'does not call private methods' do
        expect { described_class.new.run }.to change { Article.count }.by(0)
      end
    end
  end
end
