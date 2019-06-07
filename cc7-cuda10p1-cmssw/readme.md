# Running Patatrack CMSSW release with Ecal Reco on Nvidia GPU inside the Docker Container

## Assumptions for the host
- assume Nvidia Drivers + CUDA Toolkit installation
- assume docker + nvidia docker-ce 2
- to run on a machine, default runtime does not need to be `nvidia`, only to build images

## Build an image
- To build, the default the docker runtime must be set to `nvidia`
- see here [docker stuff](https://github.com/NVIDIA/nvidia-docker/wiki/Advanced-topics#default-runtime)
- To build
```
sudo docker build -t <image name> .
```

## To run 
- the image that is built is generic, but here assume we are on `bench-dev-gpu`
```
sudo docker run --runtime=nvidia -u 0 -v /home/cmscuda/:/shared  -it <image id> /opt/cms/run_release_shared_volume.sh /opt/cms CMSSW_10_6_0_pre2_Patatrack_CUDA_10_1 /shared/cmssw_configs/ecalOnly_shared.py
```
- `--runtime=nvidia` - specify the runtime
- `-u 0` - dirty workaround. not seeing (not having permissions for) shared volume by `cmsinst` user that is being used within the container
- `-v /home/cmscuda:/shared` - shared volume. _needs to be set as_ `/shared`, lazy to modify the config...
- the rest specifies the location of cmssw distribution within the running container and the config to be called
