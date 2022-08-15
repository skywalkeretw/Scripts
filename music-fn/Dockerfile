FROM openwhisk/action-python-v3.9:nightly

RUN apt update  \
    && apt upgrade -y \
    && apt install -y \
    curl \
    ffmpeg \
    python-mutagen \
    python3-mutagen

# Install Youtube-dl
RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl \
    && chmod +x /usr/local/bin/youtube-dl

# Install Downloader and Converter Script
RUN curl -o /usr/local/bin/music https://raw.githubusercontent.com/skywalkeretw/Scripts/master/music/download.sh && \
    chmod +x /usr/local/bin/music

# Install gitlab CLI
RUN curl -sL https://j.mp/glab-cli | sh 

ENV PATH="${PATH}:/usr/bin"

# Create ssh folder 
RUN mkdir /root/.ssh

# Install gitpython tool
RUN pip install \
    --upgrade pip \
    gitpython \
    python-gitlab