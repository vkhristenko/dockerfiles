FROM cern/cc7-base

# install all the rpms
RUN yum update -y && \
    yum install -y sudo vim rsync krb5-workstation e2fsprogs xauth \
                   git bash-completion bash-completion-extras \
                   tcsh openssl perl-Digest-MD5 perl-Switch perl-Env \
                   voms-clients xrootd-client \
                   http://linuxsoft.cern.ch/wlcg/centos7/x86_64/wlcg-repo-1.0.0-1.el7.noarch.rpm \
                   HEP_OSlibs wlcg-voms-cms \ 
                   http://repository.egi.eu/sw/production/umd/4/centos7/x86_64/updates/umd-release-4.1.3-1.el7.centos.noarch.rpm \
                   ca-policy-egi-core

# add 2 users: cmsbuild and cmsinst
RUN groupadd -g 500 cmsinst && adduser -u 500 -g 500 cmsinst && install -d /opt && install -d -o cmsinst /opt/cms
RUN groupadd -g 501 cmsbuild && adduser -u 501 -g 501 cmsbuild
RUN chown cmsinst:cmsinst -R /opt/cms

# cmssw can not be installed as root, switch to cmsinst and perform the installation 
# of cmssw. Note, it's not built from sources, but simply downloads the rpms.
USER cmsinst
WORKDIR /opt/cms
RUN wget -O /opt/cms/bootstrap.sh http://cmsrep.cern.ch/cmssw/repos/bootstrap.sh
RUN chmod 755 /opt/cms/bootstrap.sh

# bootstrap
RUN /opt/cms/bootstrap.sh -a slc7_amd64_gcc630 -r cms -path /opt/cms setup

# install the externals + release
RUN /opt/cms/common/cmspkg -a slc7_amd64_gcc630 -y install cms+cmssw+CMSSW_10_0_0

# set up the SITECONF
RUN mkdir /opt/cms/SITECONF
RUN mkdir /opt/cms/SITECONF/local-site
RUN ln -s /opt/cms/SITECONF/local-site /opt/cms/SITECONF/local
RUN mkdir  /opt/cms/SITECON/local/PhEDEx
ADD storage.xml /opt/cms/SITECON/local/PhEDEx
RUN mkdir /opt/cms/SITECON/local/JobConfig
ADD site-local-config.xml /opt/cms/SITECON/local/PhEDEx
