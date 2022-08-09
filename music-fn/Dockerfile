FROM openwhisk/action-python-v3.9:nightly

RUN apt update  \
    && apt upgrade -y \
    && apt install -y \
    curl \
    ffmpeg \
    python3-mutagen

RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl \
    && chmod +x /usr/local/bin/youtube-dl

RUN curl -L -o /usr/local/bin/music https://github.com/skywalkeretw/Scripts/blob/master/music/download.sh

RUN chmod +x /usr/local/bin/music

RUN pip install \
    --upgrade pip \
    gitpython