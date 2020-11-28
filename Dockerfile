from jenkins/jenkins:lts-alpine
USER root

# Pipeline
RUN /usr/local/bin/install-plugins.sh workflow-aggregator && \
    /usr/local/bin/install-plugins.sh github && \
    /usr/local/bin/install-plugins.sh ws-cleanup && \
    /usr/local/bin/install-plugins.sh greenballs && \
    /usr/local/bin/install-plugins.sh simple-theme-plugin && \
    /usr/local/bin/install-plugins.sh kubernetes && \
    /usr/local/bin/install-plugins.sh docker-workflow && \
    /usr/local/bin/install-plugins.sh kubernetes-cli && \
    /usr/local/bin/install-plugins.sh github-branch-source 




# install   Docker, AWS  ； install docker may take couple of hours ，even a day base on Internet condition
# if you dont wait that long ,welcome to skip it 

# modify apk source
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories  

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories   
RUN apk add --no-cache docker \
    gettext
   
# install Dotnet Sdk
# COPY dotnet-install.sh /usr/share/jenkins/ref/dotnet-install.sh
# RUN /usr/share/jenkins/ref/dotnet-install.sh -c 3.1

# Kubectl
RUN  wget https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

# Need to ensure the gid here matches the gid on the host node. We ASSUME (hah!) this
# will be stable....keep an eye out for unable to connect to docker.sock in the builds
# RUN delgroup ping && delgroup docker && addgroup -g 999 docker && addgroup jenkins docker

# See https://github.com/kubernetes/minikube/issues/956.
# THIS IS FOR MINIKUBE TESTING ONLY - it is not production standard (we're running as root!)
RUN chown -R root "$JENKINS_HOME" /usr/share/jenkins/ref
