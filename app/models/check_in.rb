class CheckIn < ApplicationRecord
  # Associations
  belongs_to :child
  belongs_to :parent, optional: true

  # Callbacks
  before_validation :set_full_name_and_email

  # Validations
  validates :child_id, :check_in_time, presence: true
  validates :parent_id, presence: true, if: -> { parent.present? }

  # Scopes
  scope :active, -> { where(check_out_time: nil) }

  private

  def set_full_name_and_email
    if parent.present?
      self.full_name = parent.full_name
      self.parent_email = parent.email
    else
      self.full_name = nil
      self.parent_email = nil
    end
  end
end
