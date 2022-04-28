This example deploys a Cognito user pool and client in order to deploy an OIDC
SSO where user accounts are managed within AWS, and users login through a
hosted AWS URL, before redirecting back to your application(s).

This is a solution makes use of SES for emailing, so that you can specify
what email addresses send password resets etc.
