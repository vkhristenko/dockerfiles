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
```
sudo docker run --runtime=nvidia -it <image name> /opt/cms/run_release_shared_volume.sh /opt/cms CMSSW_10_6_0_Patatrack /opt/cms/ecalOnly.py
```
- `--runtime=nvidia` - specify the runtime
- the rest specifies the location of cmssw distribution within the running container and the config to be called
