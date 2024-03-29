# Configure Solidus Preferences
# See http://docs.solidus.io/Spree/AppConfiguration.html for details

# Solidus version defaults for preferences that are not overridden
Spree.load_defaults '3.2.0'

Spree.config do |config|
  config.currency = "RUB"
  config.generate_api_key_for_all_roles = true

  # config.product_image_styles = {}
  # config.taxon_styles = {}

  # Uncomment to stop tracking inventory levels in the application
  config.track_inventory_levels = false

  # When set, product caches are only invalidated when they fall below or rise
  # above the inventory_cache_threshold that is set. Default is to invalidate cache on
  # any inventory changes.
  # config.inventory_cache_threshold = 3

  # Configure adapter for attachments on products and taxons (use ActiveStorageAttachment or PaperclipAttachment)
  config.image_attachment_module = 'Spree::Image::ActiveStorageAttachment'
  config.taxon_attachment_module = 'Spree::Taxon::ActiveStorageAttachment'

  # Defaults
  # Permission Sets:

  # Uncomment and customize the following line to add custom permission sets
  # to a custom users role:
  # config.roles.assign_permissions :role_name, ['Spree::PermissionSets::CustomPermissionSet']

  # Custom logo for the admin
  # config.admin_interface_logo = "logo/solidus.svg"

  # Gateway credentials can be configured statically here and referenced from
  # the admin. They can also be fully configured from the admin.
  #
  # Please note that you need to use the solidus_stripe gem to have
  # Stripe working: https://github.com/solidusio-contrib/solidus_stripe
  #
  # config.static_model_preferences.add(
  #   Spree::PaymentMethod::StripeCreditCard,
  #   'stripe_env_credentials',
  #   secret_key: ENV['STRIPE_SECRET_KEY'],
  #   publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  #   server: Rails.env.production? ? 'production' : 'test',
  #   test_mode: !Rails.env.production?
  # )
end


Spree::Api::Config.configure do |config|
  config.requires_authentication = true
  config.user_attributes += [:phone, :name, :dob, :avatar_url, :notifications, :spree_api_key]
end

# Spree::PermittedAttributes.user_attributes += [:name, :dob, :notifications, :avatar]

Spree::Auth::Config[:confirmable] = false

Devise.setup do |config|
  config.navigational_formats = ['*/*', :html, :turbo_stream]
end


Spree::Backend::Config.configure do |config|
  config.locale = 'ru'

  config.menu_items << config.class::MenuItem.new(
    :content, 'edit',
    label: :content,
    partial: 'spree/admin/shared/content_sub_menu',
    url: :admin_reviews_path,
    position: 5
  )
  
  # Custom frontend product path
  # config.frontend_product_path = ->(template_context, product) {
  #   template_context.spree.product_path(product)
  # }
end

# Spree.user_class = "Spree::LegacyUser"

# Rules for avoiding to store the current path into session for redirects
# When at least one rule is matched, the request path will not be stored
# in session.
# You can add your custom rules by uncommenting this line and changing
# the class name:
#
# Spree::UserLastUrlStorer.rules << 'Spree::UserLastUrlStorer::Rules::AuthenticationRule'
