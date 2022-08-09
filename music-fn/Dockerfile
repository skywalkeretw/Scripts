FROM openwhisk/action-python-v3.9:nightly

RUN apt update  \
    && apt upgrade -y \
    && apt install -y \
    curl \
    ffmpeg \
    python3-mutagen

RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl \
    && chmod +x /usr/local/bin/youtube-dl

COPY ../music/download.sh /usr/local/bin/music

RUN chmod +x /usr/local/bin/music

RUN pip install \
    --upgrade pip \
    gitpython