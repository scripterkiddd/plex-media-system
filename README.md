# plex-media-system
A docker-compose based media system for running plex and additional services 

| Service      | Port  | Description        |
| ------------ | ----- | ------------------ |
| Deluge       | 8112  | [Torrent Downloader](https://github.com/deluge-torrent/deluge) |
| Sonarr       | 8989  | [TV Show PVR](https://github.com/Sonarr/Sonarr)       |
| Radarr       | 7878  | [Movie PVR](https://github.com/Radarr/Radarr)          |
| Tautulli     | 8181  | [Plex analytics](https://github.com/Tautulli/Tautulli)     |
| Jackett      | 9117  | [Index normalizer](https://github.com/Jackett/Jackett)   |
| Plex         | 32400 | It's plex          |


This setup assumes you have 4 directory to run from ( look at the .env ):

/share/Docker -> Where docker logs, configs and databases goes

/share/Multimedia -> Where plex will look for downloaded content

/share/Download -> Where transmission will download to 

/share/DockerTemp -> Where to put tmp files

#### Setup
Before you run anything you need to fill out the .env file

Plex:

CLAIM_CODE= https://github.com/plexinc/pms-docker

NAME= Is the name that will show on the top of plex

IP= The server ip, ex: 192.168.1.25

VPN:

I've only tested this with PIA, normal user/pass will work

Make sure you have a .openvpn config file in the config dir for deluge: $config/openvpn/theworld.openvpn
If using PIA make sure you select a site that has port fowarding enabled.

#### Usage
```
docker-compose pull
docker-compose up -d
```
To upgrade the containers:
```
docker-compose pull
docker-compose down
docker-compose up -d
```


#### Initial Configuration

##### Jackett
Load Indexers into Jackett

##### Sonarr
- setup deluge under /settings/downloadclient, you'll need to show Advanced Settings ( slider on the tab )

| Settings  | Value              |
| --------  | ------------------ |
| host      | deluge       |
| port      | 8112               |
| Url Base  | /deluge      |
| Directory | /data/completed/tv |

- Add Indexers to Jackett, then add them as "Torznab" indexes under SERVERIP:8989/settings/indexers. All indexes in jackett can be add with 1 torznab index like this:

![alt text](https://i.imgur.com/yPSKg42.png "Jackett Sonarr settings")

NOTE: When adding TV shows, set the path the /tv/

##### Radarr
- setup deluge under /settings/downloadclient, you'll need to show Advanced Settings ( slider on the tab )

| Settings  | Value                  |
| --------  | ---------------------- |
| host      | deluge           |
| port      | 8112                   |
| Url Base  | /deluge          |
| Directory | /data/completed/movies |

- Add Indexers to Jackett, then add them as "Torznab" index under SERVERIP:7878/settings/indexers. All indexes in jackett can be add with 1 torznab index like this:

![alt text](https://i.imgur.com/yPSKg42.png "Jackett Radarr settings")

NOTE: When adding Movies, set the path to /movies/

##### Plex
- Add Library, Movies, Add Folder, /data/Videos/Movies
- Add Library, TV, Add Folder, /data/Videos/TV
- Plex should automagically pick up content as it's downloaded



#### Additional notes
The deluge/openvpn container will sometimes have "errors" in it's logs. Unless your unable to download/upload anything it shoulden't be a problem.
