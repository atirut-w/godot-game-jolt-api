# Trophy management
This page list the functions that are part of the `/trophies/` endpoint of the Game API.

## Granting and revoking trophies
!!! info
    To get the ID of a trophy, head to the Trophies page under the Game API tab of your game's dashboard

### Granting a trophy
`#!gd func grant_trophy(id: int) -> bool`

### Revoking a trophy
`#!gd func revoke_trophy(id: int) -> bool`
