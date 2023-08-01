class DestroyUnconfirmedUsersJob < ApplicationJob

  queue_as :default

  def perform
    Spree.user_class
      .where(confirmed_at: nil)
      .where('last_request_at < ?', Time.now - Spree.user_class.confirmation_token_lifetime)
      .destroy_all
  end

end
