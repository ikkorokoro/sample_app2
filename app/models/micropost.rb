class Micropost < ApplicationRecord
  belongs_to :user#delault の挙動が動いて
  #Micropostモデルのuser_idとUserモデルが紐付いていた
  default_scope -> { self.order(created_at: :desc) }#データベースから要素を取得したときの、デフォルトの順序を指定するメソッド
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
