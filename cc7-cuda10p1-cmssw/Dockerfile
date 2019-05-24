FROM nvidia/cuda:10.1-devel-centos7

# install all the rpms
RUN yum update -y && \
    yum install -y sudo vim rsync krb5-workstation e2fsprogs xauth \
                   git bash-completion bash-completion-extras \
                   tcsh openssl perl-Digest-MD5 perl-Switch perl-Env \
                   voms-clients xrootd-client \
                   http://linuxsoft.cern.ch/wlcg/centos7/x86_64/wlcg-repo-1.0.0-1.el7.noarch.rpm &&
    yum insatll -y HEP_OSlibs wlcg-voms-cms \ 
                   http://repository.egi.eu/sw/production/umd/4/centos7/x86_64/updates/umd-release-4.1.3-1.el7.centos.noarch.rpm \
                   ca-policy-egi-core

# add cmsinst user: can not run bootstrapping as root
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

# install the externals + release
RUN /opt/cms/common/cmspkg -a slc7_amd64_gcc700 -r cms.patatrack -y install cms+cmssw+CMSSW_10_6_0_pre2_Patatrack_CUDA_10_1

# set up the SITECONF
RUN mkdir /opt/cms/SITECONF
RUN mkdir /opt/cms/SITECONF/local-site
RUN ln -s /opt/cms/SITECONF/local-site /opt/cms/SITECONF/local
RUN mkdir  /opt/cms/SITECONF/local/PhEDEx
ADD storage.xml /opt/cms/SITECONF/local/PhEDEx
RUN mkdir /opt/cms/SITECONF/local/JobConfig
ADD site-local-config.xml /opt/cms/SITECONF/local/JobConfig
