Before you create your container, you must decide on the type of networking you wish to use. There are essentially three types of networking available:

bridge (default)
host
macvlan

The bridge networking creates an entirely new network within the host and runs containers within there. This network is connected to the physical network via an internal router and docker configures this router to forward certain ports through to the containers within. The host networking uses the IP address of the host running docker such that a container's networking appears to be the host rather than separate. The macvlan networking creates a new virtual computer on the network which is the container. For purposes of setting up a plex container, the host and macvlan are very similar in configuration.

Using host or macvlan is the easier of the three setups and has the fewest issues that need to be worked around. However, some setups may be restricted to only running in the bridge mode. Plex can be made to work in this mode, but it is more complicated.

For those who use docker-compose, this repository provides the necessary YML template files to be modified for your own use.



Host Networking

docker run \
-d \
--name plex \
--network=host \
-e TZ="<timezone>" \
-v <path/to/plex/database>:/root \
-v <path/to/media>:/media \
prasad7676/plex

docker run \
-d \
--name plex \
-p 32400:32400/tcp \
-p 3005:3005/tcp \
-p 8324:8324/tcp \
-p 32469:32469/tcp \
-p 1900:1900/udp \
-p 32410:32410/udp \
-p 32412:32412/udp \
-p 32413:32413/udp \
-p 32414:32414/udp \
-e TZ="<timezone>" \
-e ADVERTISE_IP="http://<hostIPAddress>:32400/" \
-h <HOSTNAME> \
-v <path/to/plex/database>:/root \
-v <path/to/media>:/media \
prasad7676/plex


Macvlan Networking

docker run \
-d \
--name plex \
--network=physical \
--ip=<IPAddress> \
-e TZ="<timezone>" \
-h <HOSTNAME> \
-v <path/to/plex/database>:/root \
-v <path/to/media>:/media \
prasad7676/plex

Similar to Host Networking above with these changes:

The network has been changed to physical which is the name of the macvlan network (yours is likely to be different).
The --ip parameter has been added to specify the IP address of the container. This parameter is optional since the network may specify IPs to use but this paramater overrides those settings.
The -h <HOSTNAME> has been added since this networking type doesn't use the hostname of the host.

Note: In this configuration, you must do some additional configuration:

1. If you wish your Plex Media Server to be accessible outside of your home network, you must manually setup port forwarding on your router to forward to the ADVERTISE_IP specified above. By default you can forward port 32400, but if you choose to use a different external port, be sure you configure this in Plex Media Server's Remote Access settings. With this type of docker networking, the Plex Media Server is essentially behind two routers and it cannot automatically setup port forwarding on its own.

2. (Plex Pass only) After the server has been set up, you should configure the LAN Networks preference to contain the network of your LAN. This instructs the Plex Media Server to treat these IP addresses as part of your LAN when applying bandwidth controls. The syntax is the same as the ALLOWED_NETWORKS below. For example 192.168.1.0/24,172.16.0.0/16 will allow access to the entire 192.168.1.x range and the 172.16.x.x range.
