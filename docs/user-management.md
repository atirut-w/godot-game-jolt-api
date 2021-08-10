# User management

## Authenticating a user
While the Game API itself does not have an authentication system, it provides a way to validate if a set of username and token are valid.

This API requires that you use the `#!gd authenticate()` function to validate the credentials to use API calls that requires username and token. It is possible to bypass this functionality by setting `is_authenticated` to true, but doing so is not recommended.

To authenticate, use the `#!gd authenticate()` function like this: `#!gd var success = yield(GameJolt.authenticate("username", "token"), "completed")`
