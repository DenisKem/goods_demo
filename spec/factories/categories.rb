# == Schema Information
#
# Table name: categories
#
#  id             :bigint(8)        not null, primary key
#  name           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  products_count :integer          default(0), not null
#

FactoryGirl.define do
  factory :category do
    sequence(:name) { |i| "Category ##{i}" }
  end
end
