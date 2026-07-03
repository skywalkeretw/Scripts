# MangaDex to PDF Downloader

A bash script to download manga chapters from MangaDex and convert them into PDF files.

## Features

- ✅ Downloads all available chapters from a MangaDex title
- ✅ Converts chapter images to PDF format
- ✅ Proper chapter ordering (by volume and chapter number)
- ✅ Skips already downloaded chapters
- ✅ Handles external/official content gracefully
- ✅ Retry logic for failed downloads
- ✅ Rate limiting to respect API guidelines
- ✅ Progress tracking and detailed reporting

## Prerequisites

The script requires the following tools to be installed:

- **curl** - For making API requests
- **jq** - For parsing JSON responses
- **img2pdf** - For converting images to PDF

### Installation on macOS

```bash
brew install curl jq img2pdf
```

### Installation on Linux (Ubuntu/Debian)

```bash
sudo apt-get update
sudo apt-get install curl jq img2pdf
```

### Installation on Linux (Fedora/RHEL)

```bash
sudo dnf install curl jq img2pdf
```

## Usage

### Basic Usage

```bash
./mangadex_title_to_pdfs.sh <mangadex_title_url>
```


### Finding a MangaDex Title URL

1. Go to [MangaDex](https://mangadex.org/)
2. Search for your desired manga
3. Copy the URL from the browser address bar
4. The URL should look like: `https://mangadex.org/title/TITLE_ID/manga-name`

## How It Works

1. **Extracts Title ID** - Parses the UUID from the provided URL
2. **Fetches Manga Info** - Gets the manga title and metadata
3. **Lists Chapters** - Retrieves all English chapters in order
4. **Filters Content** - Identifies downloadable vs external chapters
5. **Downloads Images** - Fetches all pages for each chapter
6. **Creates PDFs** - Converts images to PDF format
7. **Organizes Files** - Saves PDFs in a directory named after the manga

## Output Structure

```
Manga Title/
├── Manga_Title_Vol1_Ch1_Chapter_Name.pdf
├── Manga_Title_Vol1_Ch2_Chapter_Name.pdf
├── Manga_Title_Vol2_Ch3_Chapter_Name.pdf
└── ...
```

## Important Notes

### External/Official Content

Some manga chapters on MangaDex are hosted externally (e.g., MangaPlus, official publisher sites). These chapters:
- Cannot be downloaded through this script
- Will be skipped with an informative message
- Can be read for free on their respective platforms

Example output for external content:
```
⏭ Skipping Vol=1 Ch=1 — Chapter Name (External/Official content: https://mangaplus.shueisha.co.jp/viewer/...)
```

### Rate Limiting

The script includes built-in rate limiting to respect MangaDex's API guidelines:
- 1 second delay between API calls
- 5 second backoff on rate limit errors (HTTP 429)
- Automatic retry logic (up to 3 attempts)

### Resume Support

The script automatically skips chapters that have already been downloaded, allowing you to:
- Resume interrupted downloads
- Re-run the script to get new chapters
- Avoid re-downloading existing content

## Troubleshooting

### "Command not found" errors

Make sure all prerequisites are installed:
```bash
which curl jq img2pdf
```

### "Could not extract title ID"

Ensure you're using the correct URL format:
- ✅ Correct: `https://mangadex.org/title/UUID/manga-name`
- ❌ Wrong: `https://mangadex.org/chapter/UUID`

### All chapters show as "External/Official content"

This means the manga only has official publisher chapters on MangaDex. You can:
- Read them online at the provided external URL (usually free)
- Look for fan-translated versions from different scanlation groups
- Try a different manga title

### HTTP 429 (Rate Limited)

The script handles this automatically with backoff. If it persists:
- Wait a few minutes before retrying
- Check if you're running multiple instances of the script

### Failed downloads

The script includes retry logic, but if chapters consistently fail:
- Check your internet connection
- Verify the manga is still available on MangaDex
- Try again later (server might be temporarily unavailable)


### Make the script executable (first time only)
```bash
chmod +x mangadex_title_to_pdfs.sh
```
