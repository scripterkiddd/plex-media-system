# plex-media-system
A docker-compose based media system for running plex and additional services 

| Service      | Port  | Description        |
| ------------ | ----- | ------------------ |
| Transmission | 9091  | [Torrent Downloader](https://github.com/transmission/transmission) |
| Sonarr       | 8989  | [TV Show PVR](https://github.com/Sonarr/Sonarr)       |
| Radarr       | 7878  | [Movie PVR](https://github.com/Radarr/Radarr)          |
| PlexPy       | 8181  | [Plex analytics](https://github.com/JonnyWong16/plexpy)     |
| Jackett      | 9117  | [Index normalizer](https://github.com/Jackett/Jackett)   |
| Plex         | 32400 | It's plex          |

Tested and working with:
Docker version 17.09.0-ce, build afdb6d4
docker-compose version 1.13.0, build 1719ceb
Ubuntu 16

This setup assumes you have 3 directory to run from:
/share/Docker -> Where docker logs, configs and databases goes
/share/Multimedia -> Where plex will look for downloaded content
/share/Download -> Where transmission will download to 

#### Setup
Before you run anything you need to fill out the .env file
Plex:
CLAIM_CODE= https://github.com/plexinc/pms-docker
NAME= Is the name that will show on the top of plex
IP= The server ip, ex: 192.168.1.25
VPN:
I've only tested this with PIA, normal user/pass will work

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
setup transmission under /settings/downloadclient, you'll need to show Advanced Settings ( slider on the tab )

| Settings  | Value              |
| --------  | ------------------ |
| host      | transmission       |
| port      | 9091               |
| Url Base  | /transmission      |
| Directory | /data/completed/tv |

Add Indexers under /settings/indexers. Jackett has instructions on the bottom of it's UI
NOTE: When adding TV shows, set the path the /tv/

##### Radarr
setup transmission under /settings/downloadclient, you'll need to show Advanced Settings ( slider on the tab )

| Settings  | Value                  |
| --------  | ---------------------- |
| host      | transmission           |
| port      | 9091                   |
| Url Base  | /transmission          |
| Directory | /data/completed/movies |

Add Indexers under /settings/indexers. Jackett has instructions on the bottom of it's UI
NOTE: When adding Movies, set the path to /movies/

##### Plex
Add Library, Movies, Add Folder, /data/Videos/Movies
Add Library, TV, Add Folder, /data/Videos/TV
Plex should automagically pick up content as it's downloaded



#### Additional notes
Transmission will attempt to unrar files it detects as .rar, this works *most* of the time.

If you're having trouble with transcode streaming, it can help to add a local transcode directory. In my case I made a small (4GB) [tmpfs](https://www.jamescoyle.net/how-to/943-create-a-ram-disk-in-linux) at /transcode and added that to the list of volumes in docker compose under the plex service. Should look like this:
```
	volumes:
      - ${CONFIG_DIR}/plex:/config
      - ${MEDIA_DIR}:/data
      - /etc/localtime:/etc/localtime:ro
      - /transcode:/transcode 
```
Then set plex to use that under it's server settings/transcoder

PRs are welcome