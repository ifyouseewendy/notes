## OAuth 1.0 Example

### Client should prepare for

1. client credentials

  + client identifier
  + client shared secret

2. server-side api endpoints

  + **Temporary Credentials Request**: `{server_site}/initiate`
  + **Resource Owner Authorization URL**: `{server_site}/authorize`
  + **Token Credentials Request**: `{server_site}/token`

3. client-side callback api

  `{client_site}/ready`

### Request 1, Temporary Credentials Request

请求 **temporary_credential**。

***CLIENT***

```
POST {server_site}/initiate

param
  :oauth_consumer_key
  :oauth_callback
```

***SERVER*** returns a set of **temporary_credential**.

```
oauth_token={temporary_credential}
oauth_secret
```

### Request 2, Resource Owner Authorization Request

引导用户认证和授权，获得 *temporary_verifier*。

1. ***CLIENT*** redirect user to `{server_site}/authorize?oauth_token={temporary_credential}`

2. User sign in && approve granting access

3. ***SERVER*** redirect to `{client_site}/ready?oauth_token={temporary_credential}&&oauth_verifier={temporary_verifier}`

### Request 3, Token Credentials Request

使用 **temporary_credential** 和 **temporary_verifier** 请求获取 **token_credential**。

***CLIENT***

```
POST {server_site}/token

param
  :oauth_consumer_key
  :oauth_token
  :oauth_verifier
```

***SERVER*** returns a set of **token_credential**.


