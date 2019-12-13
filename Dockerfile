# For running Lilypond on MacOS Catalina and higher
# TODO: better scripting for this :-/ (e.g. can use this Docker
#   image to invoke Lilypond but not build.py)
#
# Usage:
#   docker build . -t lilypond 
#   docker run --rm -v $(pwd):/app -w /app lilypond:latest lilypond <carol>.ly  && open <carol>.pdf
#
# Credit: Kyle W. Baldwin (https://kylebaldw.in/posts/2019/running-lilypond-on-catalina/)

# Select the base system 
FROM python:3.6

# Setup the locales for the Ubuntu system.  Because the base image is a bare bones 
# setup, this is needed to get things in the correct language. 
# https://hub.docker.com/_/ubuntu/ 
# Always use update with the install subcommand
# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Set LANG to us.utf8
ENV LANG en_US.utf8

# Set tell the installer that we are working in a noninteractive ENV 
ENV DEBIAN_FRONTEND noninteractive

# Install Lilypond. 
RUN apt-get update && apt-get -y install lilypond

# Install LaTeX
RUN apt-get update -q && apt-get install -qy \
    texlive-full \
    python-pygments gnuplot \
    make git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
ADD . .
RUN pip install -r requirements.txt