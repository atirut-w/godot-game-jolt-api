# Authenticate
`#!gd func authenticate(username: String, token: String) -> bool`

Usage: `#!gd var success = yield(GameJolt.authenticate("username", "token"), "completed")`

While the Game API itself does not have an authentication system, it provides a way to validate if a set of username and token are valid.

This API requires that you use this function to validate the credentials to use API calls that requires username and token. It is possible to bypass this functionality by setting `is_authenticated` to true, but doing so is not recommended.
