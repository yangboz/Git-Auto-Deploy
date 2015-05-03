FROM ubuntu:15.04
MAINTAINER Chivorotkiv <chivorotkiv@omich.net>
LABEL Version="0.0.1" License="MIT"

RUN apt-get update && \
    apt-get -y -q upgrade && \
    apt-get --no-install-recommends -q -y install \
        python ssh git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd gitdeploy --uid 2111 -d /home/gitdeploy && \
    mkdir -p /home/gitdeploy && \
    chown gitdeploy:gitdeploy -R /home/gitdeploy

ADD GitAutoDeploy.py /opt/git-auto-deploy/
ADD lock.sh /opt/git-auto-deploy/
ADD unlock.sh /opt/git-auto-deploy/

ONBUILD ADD GitAutoDeploy.conf.json /opt/git-auto-deploy/
ONBUILD USER gitdeploy
ONBUILD EXPOSE 8001
ONBUILD WORKDIR /opt/git-auto-deploy
ONBUILD CMD ["python", "GitAutoDeploy.py"]








# ###### SSH #####
# #
# # When you will building container you are supposed to create gitlab key and add known_hosts. You can do it by different ways. That's why I don't add it with ONBUILD directive.
# # I'm just providing you with example:
#
# ADD gitlab_rsa /home/first/.ssh/gitlab_rsa
# ADD known_hosts /home/first/.ssh/known_hosts
# RUN echo 'Host gitlab_com gitlab.com\nHostname gitlab.com\nIdentityFile ~/.ssh/gitlab_rsa\n' >> /home/first/.ssh/config
# RUN cp -R /home/first/.ssh /root/
#
# # You can generate key and known_hosts with following comand:
# #     ssh-keygen -t rsa
# #     ssh-keyscan -t rsa github.com > ~/.ssh/known_hosts
# #
# #################

