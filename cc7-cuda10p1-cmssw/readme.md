# Running Patatrack CMSSW release with Ecal Reco on Nvidia GPU inside the Docker Container using CMS Open Data

## Assumptions for the host
- assume Nvidia Drivers + CUDA Toolkit installation
- assume docker + nvidia docker-ce 2. Some info on how to bring all of that is [here](../docs/gpudev_install_readme.md)
- to run on a machine, default runtime does not need to be `nvidia`, only to build images
- assume we can get data/conditions over htpp

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
- data is wget-ted at image build time. Number of events at this point is preset to 100, can all be configured at runtime if needed...
