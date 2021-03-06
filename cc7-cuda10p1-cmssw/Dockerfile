FROM nvidia/cuda:10.1-devel-centos7

SHELL ["/bin/bash", "-c"]
RUN echo $0

# install all the rpms
RUN yum update -y && \
    yum install -y wget sudo vim rsync krb5-workstation e2fsprogs xauth && \
    yum install -y git bash-completion bash-completion-extras && \
    yum install -y tcsh openssl perl-Digest-MD5 perl-Switch perl-Env && \
#    yum install -y voms-clients xrootd-client && \
    yum install -y http://linuxsoft.cern.ch/wlcg/centos7/x86_64/wlcg-repo-1.0.0-1.el7.noarch.rpm && \
    yum install -y HEP_OSlibs wlcg-voms-cms && \ 
    yum install -y http://repository.egi.eu/sw/production/umd/4/centos7/x86_64/updates/umd-release-4.1.3-1.el7.centos.noarch.rpm && \
    yum install -y ca-policy-egi-core

# add 2 users: cmsbuild and cmsinst
RUN groupadd -g 500 cmsinst && adduser -u 500 -g 500 cmsinst && install -d /opt && install -d -o cmsinst /opt/cms
RUN chown cmsinst:cmsinst -R /opt/cms

# cmssw can not be installed as root, switch to cmsinst and perform the installation 
# of cmssw. Note, it's not built from sources, but simply downloads the rpms.
USER cmsinst
WORKDIR /opt/cms
RUN wget -O /opt/cms/bootstrap.sh http://cmsrep.cern.ch/cmssw/bootstrap.sh
RUN chmod 755 /opt/cms/bootstrap.sh

# bootstrap
RUN /opt/cms/bootstrap.sh -a slc7_amd64_gcc700 -r cms -path /opt/cms setup

#install externals + base release
RUN /opt/cms/common/cmspkg -a slc7_amd64_gcc700 install -y cms+cmssw+CMSSW_10_6_0

# install externals (should be coming from previous one) + patatrack release
RUN /opt/cms/common/cmspkg -a slc7_amd64_gcc700 -r cms.patatrack install -y cms+cmssw+CMSSW_10_6_0_Patatrack

# set up the SITECONF
RUN mkdir /opt/cms/SITECONF
RUN mkdir /opt/cms/SITECONF/local-site
RUN ln -s /opt/cms/SITECONF/local-site /opt/cms/SITECONF/local
RUN mkdir  /opt/cms/SITECONF/local/PhEDEx
ADD storage.xml /opt/cms/SITECONF/local/PhEDEx
RUN mkdir /opt/cms/SITECONF/local/JobConfig
ADD site-local-config.xml /opt/cms/SITECONF/local/JobConfig

# setup and launcher scripts to use
# need to switch to root to setup permissions for files
USER root
ADD setup_release_data.sh /opt/cms
ADD run_release_shared_volume.sh /opt/cms
ADD wget_data.sh /opt/cms
RUN chmod 755 /opt/cms/run_release_shared_volume.sh
RUN chmod 755 /opt/cms/setup_release_data.sh
RUN chmod 755 /opt/cms/wget_data.sh
USER cmsinst

# configure git
# git cms-init complains if the user is not random
RUN git config --global user.name "test"
RUN git config --global user.email "test@gmail.com"
RUN git config --global user.github cms-sw

# we are in /opt/cms as cmsinst user
# 0) add a cmssw config to use to /opt/cms
# 1) setup a patatrack release
# 2) merge the ecal reco branch
# 3) compile/build
# 4) wget data
ADD ecalOnly.py /opt/cms
WORKDIR /opt/cms
RUN nvidia-smi
RUN /opt/cms/setup_release_data.sh /opt/cms CMSSW_10_6_0_Patatrack
RUN /opt/cms/wget_data.sh /opt/cms
