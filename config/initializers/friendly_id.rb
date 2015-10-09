# Friendly Id default configuration
FriendlyId.defaults do |config|
  config.base = :attribute_to_slug
  config.use :slugged
end
