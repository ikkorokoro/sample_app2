class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  #default: class_name: Micropost {Model Names}sを関連づけさせようとする}
  #default: foreign_key: user_id なので記述する必要がなかった
  has_many :active_relationships,  class_name:  "Relationship",#defaultではactive_relationshipモデルを関連づけさせてしまうがそのモデルはないので関連づけしたいテーブル名を指定する
                                  foreign_key: "follower_id",#他のモデルと関連づけさせるためのカラムの指定
                                    dependent:   :destroy
  
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                    dependent:   :destroy
  
  has_many :following, through: :active_relationships, #自分がフォローしたユーザーのfollowed_idからフォローしたユーザーのデータを呼び出す。
                        source: :followed
  has_many :followers, through: :passive_relationships, 
                        source: :follower
  
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_save :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: true
   has_secure_password
   validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
   
   # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
    # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
 # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?#remember_digest.nilによるバグの解消
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
   # アカウントを有効にする
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end
  
  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  # 試作feedの定義
  # 完全な実装は次章の「ユーザーをフォローする」を参照
    # ユーザーのステータスフィードを返す
    
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)#ユーザーのMicropostを全て呼び出す
   #Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
     #following_ids: following_ids, user_id: id)
  end
  
  # ユーザーをフォローする
  def follow(other_user)
    following << other_user#自分がフォローしているユーザーの配列のデータの中に新しくフォローしたユーザーを追加する
  end
  
  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  
   # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
  
private
  
  def downcase_email
    self.email = email.downcase
  end
  
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
