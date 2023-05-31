class Article < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :section, presence: true
end
