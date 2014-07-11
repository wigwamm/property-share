stripe_keys = YAML.load(File.read("#{Rails.root}/config/secrets.yml"))[Rails.env].symbolize_keys!
Stripe.api_key = stripe_keys[:stripe_api_key]
STRIPE_PUBLIC_KEY = stripe_keys[:stripe_publishable_key]