FROM python:3.9

RUN apt update  \
    && apt upgrade -y \
    && apt install -y \
    curl \
    ffmpeg \
    python3-mutagen 

RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/youtube-dlp \
    && chmod +x /usr/local/bin/youtube-dlp

COPY download.sh /usr/local/bin/music

RUN chmod +x /usr/local/bin/music

WORKDIR /out

ENTRYPOINT [ "music" ]

# Usage:
# docker run -v $(pwd):/out lukeroy/youtube2music <SONG> <ARTIST> <ALBUM> <URL>
#./download.sh "NO MIND" "NO MIND" "MILKBLOOD" "https://www.youtube.com/watch?v=VsEJ5tqRUVM"