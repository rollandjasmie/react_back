Rails.configuration.stripe={
    :publishable_key => 'pk_test_92jRN5ep4tUTlxEmPpGreRSp00qla0JaxG',
    :secret_key => 'sk_test_BRQaeM8WDoruWTuClnLIdfrZ00aN8sngST'
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]