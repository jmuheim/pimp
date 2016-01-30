class Document < ActiveRecord::Base
  has_paper_trail only: [:name, :description, :content]

  validates :name, presence: true

  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: -> attributes {
    # Ignore lock_version and _destroy when checking for attributes
    attributes.all? { |key, value| %w(_destroy lock_version).include?(key) || value.blank? }
  }

  def content_for_html
    content.lines.map do |line|
      images.each do |image|
        line.gsub! /\(#{image.identifier}\)/, "(#{image.file.url})"
      end

      line
    end.join
  end
end
