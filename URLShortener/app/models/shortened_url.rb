# == Schema Information
#
# Table name: shortened_urls
#
#  id         :integer          not null, primary key
#  short_url  :string
#  long_url   :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'securerandom'

class ShortenedUrl < ApplicationRecord
  validates :short_url, presence: true, uniqueness: true

  def self.random_code
    code = SecureRandom::urlsafe_base64(16)
    while ShortenedUrl.exists?(:short_url => code)
      code = SecureRandom::urlsafe_base64(16)
    end
    code
  end

  def self.create!(user, long)
    user_id = user.id
    ShortenedUrl.new(short_url: ShortenedUrl.random_code, long_url: long, user_id: user_id).save
  end

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.visits.select(:visitor_id).distinct.count
  end

  def num_recent_uniques
    ten_mins_ago = 10.minutes.ago
    # self.visits.where("created_at > #{ten_mins_ago}")
    self.visits.where("created_at > ?", ten_mins_ago).select(:visitor_id).distinct.count
  end

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :short_url_id,
    class_name: :Visit

  has_many :visitors,
    through: :visits,
    source: :visitor

end
