# frozen_string_literal: true
Figaro.require_keys(
  'HOSTNAME',
  'SAML_CERTIFICATE_FILE',
  'SAML_KEY_FILE',
  'REDIS_HOST',
  'REDIS_PORT',
  'DB_ENCRYPTION_KEY',
  'MHV_HOST',
  'MHV_APP_TOKEN',
  'MHV_SM_HOST',
  'MHV_SM_APP_TOKEN',
  'EVSS_BASE_URL',
  'MVI_URL',
  'MVI_CLIENT_CERT_PATH',
  'MVI_CLIENT_KEY_PATH',
  'EVSS_S3_UPLOADS',
  'VHA_MAPSERVER_URL',
  'NCA_MAPSERVER_URL',
  'VBA_MAPSERVER_URL',
  'GOV_DELIVERY_SERVER',
  'ES_URL',
  'ES_CLIENT_CERT_PATH',
  'ES_CLIENT_KEY_PATH',
  'GIDS_HOST'
)

if Rails.env.production?
  Figaro.require_keys(
    'REPORTS_AWS_ACCESS_KEY_ID',
    'REPORTS_AWS_SECRET_ACCESS_KEY',
    'REPORTS_AWS_S3_REGION',
    'REPORTS_AWS_S3_BUCKET',
    'EDU_SFTP_HOST',
    'EDU_SFTP_USER',
    'EDU_SFTP_PASS'
  )
end
