class User < ActiveRecord::Base
  before_save { self.email = self.email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  
  validates :profile, presence: true, length: { maximum: 160 }, on: :update
  validates :prefectures_code, inclusion: { in: (JpPrefecture::Prefecture.all.map{|d|d.name}),message: "の%{value} は無効です" }, on: :update
  
  has_many :microposts
  
  has_many :following_relationships, class_name:  "Relationship", foreign_key: "follower_id", dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  
  has_many :follower_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent:   :destroy
  has_many :follower_users, through: :follower_relationships, source: :follower

  has_many :favorites
  has_many :favorite_microposts, through: :favorites, source: :micropost

  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.find_or_create_by(followed_id: other_user.id)
  end

  # フォローしているユーザーをアンフォローする
  def unfollow(other_user)
    following_relationship = following_relationships.find_by(followed_id: other_user.id)
    following_relationship.destroy if following_relationship
  end

  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    following_users.include?(other_user)
  end

  # フォローしているユーザーのつぶやきを取得
  def feed_items
    Micropost.where(user_id: following_user_ids + [self.id])
  end
  
  # お気に入りに追加
  def like(micropost)
    favorites.find_or_create_by(micropost_id: micropost.id)
  end
  
  # お気に入りを削除
  def unlike(micropost)
    fav = favorites.find_by(micropost_id: micropost.id)
    fav.destroy if fav.present?
  end
  
  # お気に入りに存在しているか確認
  def favorite?(micropost)
    Favorite.exists?(micropost_id: micropost.id, user_id: id)
  end

end