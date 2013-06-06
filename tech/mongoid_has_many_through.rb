class Person
  include Mongoid::Document
  has_many :relationships, as: :follower
  has_many :reverse_relationships, class_name: 'Relationship', as: :followed

  field :name

  def following
    Relationship.where(:follower => self).map(&:followed)
  end

  def followers
    Relationship.where(:followed => self).map(&:follower)
  end

  # fo
  def follow(other)
    Relationship.create(:follower => self, :followed => other)
  end

  # unfo
  def unfollow(other)
    Relationship.where(:follower => self, :followed => other).delete
  end

  alias_method :fo, :follow
  alias_method :unfo, :unfollow

  def followed?(other)
    !(Relationship.where(:follower => self, :followed => other).first.nil?)
  end

  alias_method :fo?, :followed?
end

class Relationship
  include Mongoid::Document
  belongs_to :follower, polymorphic: true
  belongs_to :followed, polymorphic: true
end
