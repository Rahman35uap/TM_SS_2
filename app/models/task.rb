class Task < ApplicationRecord
  belongs_to :user
  has_one_attached :file
  attr_accessor :remove_file

  validates :title, presence: true, length: { maximum: 255 }, uniqueness: { scope: :user_id, message: "has already been taken for this user" }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validate :file_validation

  private

  def file_validation
    if file.attached?
      allowed_types = ["image/png", "image/jpeg", "image/webp", "application/pdf", "text/plain", "application/zip"]
      unless allowed_types.include?(file.content_type)
        errors.add(:file, "must be a PNG, JPEG, WEBP, PDF, TXT, or ZIP file")
      end
      if file.byte_size > 25.megabytes
        errors.add(:file, "size must be less than 25MB")
      end
    end
  end
end