# Seyond driver

You need to include the driver binaries manually in the ```seyond_driver``` folder.
You can add external packages in a ```src``` folder, which will be ignored from git.

## Build image

```bash
./build_image.sh
```

## Run docker container

```bash
./run_container.sh
```

## Run the driver

```bash
ros2 run seyond seyond_node
```
