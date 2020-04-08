# Omberma

### Disclaimer

I'm using a client-server model, so I'm not sure if decentralized networking is an appropriate wording. Still, what I wanted to convey was a network without the use of one central hosted server. The servers will be the players who host rooms. Also, there could be support for Dedicated Servers. I've considered the P2P model too, but it doesn't seem like a good choice for a fast game like Omberma.

## About

I'm interested in decentralized networking, so I'll try to learn about it and apply in this game. Also, I wanted to make a game to play with my friends on mobile (via wireless ad-hoc network), without the need for Internet access. The LAN system is basically done, but the game is bare-bones.

## Online Multiplayer

Still, I would like to implement ways of connecting over the Internet too. Without a centralized server, that is. The server will still be one of the players. Based on my research, there are basically 3 ways (that I know) to accomplish what I want:

1. Port forwarding - requires the host to go to his router settings and do the process manually. Not very user-friendly.

1. UPnP - Universal Plug and Play, basically automates the port forwarding process. There are some controversies about it being insecure (if there is malware in any of the devices of your LAN that targets a vulnerability in your router, they can use UPnP to open ports to pwn you. Take this explanation with a grain of salt, I'm no expert). Still, having flaws or not, it's a very interesting technology that could be used.

1. IPv6 - Well, since IPv6 addresses are unique to each device, we don't have problem with NAT (Network Address Translation), so the communication is easier.

## Credits

### Programming

- [Godot](https://github.com/godotengine/godot) by [Godot Engine](https://github.com/godotengine).
- [ENet](https://github.com/lsalzman/enet) by [Lee Salzman](https://github.com/lsalzman).
- [multiplayer_bomber](https://github.com/godotengine/godot-demo-projects/tree/master/networking/multiplayer_bomber) by [Godot Engine](https://github.com/godotengine). 
- [LANServerBroadcast](https://github.com/Wavesonics/LANServerBroadcast) by [Wavesonics](https://github.com/Wavesonics).

### Art

Coming soon...

### Audio

- [The River](https://freemusicarchive.org/music/Rolemusic/~/The_River_1161) by [Rolemusic](https://freemusicarchive.org/music/Rolemusic).

### Fonts

- [Bitter](https://fonts.google.com/specimen/Bitter) by [Huerta Tipográfica](https://www.huertatipografica.com/en).
- [Ubuntu](https://fonts.google.com/specimen/Ubuntu) by [Dalton Maag](https://www.daltonmaag.com/).
- [Montserrat](https://fonts.google.com/specimen/Montserrat) by [Julieta Ulanovsky](https://www.fontsquirrel.com/fonts/list/foundry/julieta-ulanovsky).
