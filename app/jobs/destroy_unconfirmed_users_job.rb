class DestroyUnconfirmedUsersJob < ApplicationJob

  queue_as :default

  def perform
    Spree::User
      .where(confirmed_at: nil)
      .where('last_request_at < ?', Time.now - Spree::User.confirmation_token_lifetime)
      .destroy_all
  end

end
