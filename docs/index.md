# Home
Easily integrate your Godot game with Game Jolt's Game API!

## Why?
Even though there are other more developed plugin for integrating with the Game API, most of them rely on signals, callbacks and such. They require you to connect to a signal and provides no way to wait for API calls to finish. This prevents you from doing sophisticated things such as authenticating using only one line of code.

While this plugin also use signals internally in confunction with `#!gd yield()`, you do not need to connect to signals to do things. Instead, you use `#!gd yield(GameJolt.function_here(), "completed")` to wait for functions to finish without blocking your game's main loop.

## Useful links for contributors
- [Game API Docs](https://gamejolt.com/game-api/doc)
