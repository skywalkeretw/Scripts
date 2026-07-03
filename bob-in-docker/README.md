# Bob Shell Docker Container

This Dockerfile creates a containerized environment for running Bob Shell, a terminal-based AI assistant for software development tasks.

## What's Included

The Docker image includes:
- Ubuntu base image
- Bob Shell (latest version)
- Required dependencies: curl, bash, git, Node.js, npm, jq
- Pre-configured Bob Shell settings with auto-approval mode
- Trusted workspace directory at `/workspace`

## Prerequisites

- Docker installed on your system
- A valid Bob Shell API key

## Building the Docker Image

Build the Docker image using the following command:

```bash
docker build -t bob-shell .
```

## Running the Container

### Basic Usage

Run Bob Shell interactively with your API key:

```bash
docker run -it --rm \
  -e BOBSHELL_API_KEY="your-api-key-here" \
  bob-shell
```

### With Volume Mounting

To work with files on your host system, mount a local directory to `/workspace`:

```bash
docker run -it --rm \
  -e BOBSHELL_API_KEY="your-api-key-here" \
  -v $(pwd):/workspace \
  bob-shell
```

### Persistent Container

To keep the container running and reuse it:

```bash
# Create and start the container
docker run --name my-bob-shell -v $(pwd):/workspace -it --env BOBSHELL_API_KEY=$BOBSHELL_API_KEY bob

# Later, restart and attach to the same container
docker start -ai my-bob-shell
```

## Environment Variables

- `BOBSHELL_API_KEY` (required): Your Bob Shell API key for authentication

## Configuration

The container comes pre-configured with:
- Auto-approval mode enabled
- Telemetry disabled
- Workspace auto-trust enabled
- API key authentication method

These settings are stored in `/root/.bob/settings.json` and can be modified if needed.

## Working Directory

The default working directory is `/workspace`, which is ideal for mounting your project files.


## Notes

- The container runs with `DEBIAN_FRONTEND=noninteractive` to avoid installation prompts
- All Bob Shell data is stored in `/root/.bob/`
- The workspace at `/workspace` is automatically trusted for security
- Use `--rm` flag to automatically remove the container after exit, or omit it to keep the container for reuse
