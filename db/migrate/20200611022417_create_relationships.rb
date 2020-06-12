class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relationships, :follower_id#データベースの高速化
    add_index :relationships, :followed_id#データベースの高速化
    add_index :relationships, [:follower_id, :followed_id], unique: true#一人につき一回しか一人のユーザーにフォローできないようにするため。一意性の問題一意性を担保する
  end
end
