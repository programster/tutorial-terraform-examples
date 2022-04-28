This example deploys a Cognito user pool and client in order to deploy an OIDC
SSO where user accounts are managed within AWS, and users login through a
hosted AWS URL, before redirecting back to your application(s).

This is a really simple solution in which Cognito hosts the login UI, and
performs all of the emailing. E.g. this does not use one of your SES identities.
