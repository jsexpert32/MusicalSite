class Critique < ActiveRecord::Base
  belongs_to :track
  has_many :comments, dependent: :destroy
  has_many :soundbites
end
