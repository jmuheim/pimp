class Document < ActiveRecord::Base
  has_paper_trail only: [:name, :description, :content]

  validates :name, presence: true
end
