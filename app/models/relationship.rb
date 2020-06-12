class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"#<= これによりUserクラスのidとrelationshipモデルのfollowerが結びつく
  #default: "モデル名_id" => ✖️ follwer_id
  #デフォルトではfollowerと記述するとfollowerモデルを呼び出そうとしてしまうがモデルがないため指定する
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
