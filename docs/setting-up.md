# Setting up
Since this API is created as a Godot plugin, the only thing you have to do to get it working is enabling it in your project settings and setting up your game credentials.

## Getting your game's ID and key
1. Go to your game's dashboard on GameJolt. There are generally two ways to do this:

    1. From the home page, click on your game's name under the "Manage Games" list.

    2. From your game's page, click on the gear icon.

2. Go to the API Settings page under the Game API tab.

## Configure the API
Now that you have your game's ID and key, you can set up the game credentials from a script. It is recommended that you do this from a Game Manager[^1] script for convenience.

Example script:
```gd
GameJolt.game_id = "id here"
GameJolt.game_key = "key here"
```

[^1]: A Game Manager is usually a singleton that manage things in a game such as score, game states, etc.
