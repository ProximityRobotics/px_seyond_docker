# Seyond driver

This docker pulls and builds the latest [seyond_ros_driver](https://github.com/Seyond-Inc/seyond_ros_driver) from GitHub.

The LiDAR needs to be connected to your PC via Ethernet and you need to set your IP settings as following:

Address: ```172.168.1.42```

Netmask: ```255.255.0.0```

## Build image

```bash
./build_image.sh
```

## Run docker container

```bash
./run_container.sh
```

## Run the driver

The driver should start automatically using the ```start.py``` launch file.
