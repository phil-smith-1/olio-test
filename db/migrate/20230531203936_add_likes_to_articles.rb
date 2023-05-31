class AddLikesToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :likes, :integer, null: false, default: 0
  end
end
