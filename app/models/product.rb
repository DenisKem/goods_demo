# == Schema Information
#
# Table name: products
#
#  id          :bigint(8)        not null, primary key
#  name        :string           not null
#  category_id :integer          not null
#  price       :decimal(, )      default(0.0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_products_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#

class Product < ApplicationRecord
  belongs_to :category, counter_cache: true
  
  validates :name, :price, presence: true
  validates :name, uniqueness: {scope: :category}, allow_blank: true
  validates :price, numericality: {greater_than: 0}
end
