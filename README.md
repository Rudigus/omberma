# omberma

Disclaimer: I'm using a client-server model, so I'm not sure if decentralized networking is an appropriate wording. Still, what I wanted to convey was a network without the use of one central hosted server. The servers will be the players who host rooms. Also, there could be support for Dedicated Servers. I've considered the P2P model too, but it doesn't seem like a good choice for a fast game like Omberma.

I'm interested in decentralized networking, so I'll try to learn about it and apply in this game. Also, I wanted to make a game to play with my friends on mobile (via wireless ad-hoc network), without the need for Internet access. The LAN system is basically done, but the game is bare-bones.

Still, I would like to implement ways of connecting over the Internet too. Without a centralized server, that is. The server will still be one of the players. Based on my research, there are basically 3 ways (that I know) to accomplish what I want:

1º - Port forwarding - requires the host to go to his router settings and do the process manually. Not very user-friendly.

2º - UPnP - Universal Plug and Play, basically automates the port forwarding process. There are some controversies about it being insecure (if there is malware in any of the devices of your LAN that targets a vulnerability in your router, they can use UPnP to open ports to pwn you. Take this explanation with a grain of salt, I'm no expert). Still, having flaws or not, it's a very interesting technology that could be used.

3º - IPv6 - Well, since IPv6 addresses are unique to each device, we don't have problem with NAT (Network Address Translation), so the communication is easier.

Based on [multiplayer_bomber](https://github.com/godotengine/godot-demo-projects/tree/master/networking/multiplayer_bomber) by Godot Engine. Uses [LANServerBroadcast](https://github.com/Wavesonics/LANServerBroadcast) by Wavesonics.
