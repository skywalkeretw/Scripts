FROM python:3.9

RUN apt update  \
    && apt upgrade -y \
    && apt install -y \
    curl \
    ffmpeg \
    python3-mutagen 

RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl \
    && chmod +x /usr/local/bin/youtube-dl

COPY download.sh /usr/local/bin/music

RUN chmod +x /usr/local/bin/music

WORKDIR /out

ENTRYPOINT [ "music" ]

# Usage:
# docker run -v $(pwd):/out lukeroy/youtube2music <SONG> <ARTIST> <ALBUM> <URL>