class PendingOrder < ApplicationRecord
  belongs_to :user

  serialize :order_form_params, JSON
  serialize :order_items, JSON
end
