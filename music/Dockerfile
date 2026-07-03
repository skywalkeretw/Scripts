FROM python:3.13

RUN apt update  \
    && apt upgrade -y \
    && apt install -y \
    curl \
    ffmpeg \
    python3-mutagen 

RUN curl -L https://github.com/blackjack4494/yt-dlc/releases/latest/download/youtube-dlc -o /usr/local/bin/youtube-dlc \
    && chmod +x /usr/local/bin/youtube-dlc

COPY download.sh /usr/local/bin/music

RUN chmod +x /usr/local/bin/music

WORKDIR /out

ENTRYPOINT [ "music" ]

# Usage:
# docker run -v $(pwd):/out lukeroy/youtube2music <SONG> <ARTIST> <ALBUM> <URL>
#./download.sh "NO MIND" "NO MIND" "MILKBLOOD" "https://www.youtube.com/watch?v=VsEJ5tqRUVM"