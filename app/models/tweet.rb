class Tweet < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :message, presence: true, length: { maximum: 140 }

  has_one_attached :image

  after_commit :notify_via_email, on: :create

  private

  def notify_via_email
    # Only send notification if the tweet was successfully created
    return unless persisted?
    # Ensure image is properly attached before sending
    image.analyze if image.attached?
    TweetMailer.notify(self).deliver!
  end
end
