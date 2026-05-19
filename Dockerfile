FROM jenkins/jenkins:lts-jdk17

USER root

# Install Maven
RUN apt-get update && apt-get install -y maven && apt-get clean

USER jenkins

# Disable setup wizard (config is done via CasC)
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV CASC_JENKINS_CONFIG=/var/jenkins_home/casc.yaml

# Pre-install plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Copy Jenkins Configuration as Code
COPY casc.yaml /var/jenkins_home/casc.yaml
