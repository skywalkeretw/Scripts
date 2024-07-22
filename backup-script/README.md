# Backup Script

This script creates a ZIP file containing specified folders and copies it to a backup directory on an external hard drive. The list of directories to back up is read from a file called `backup-dirs.txt` located in the same directory as the script.

## Requirements

- Python 3.x
- `psutil` (for macOS and Linux)
- `pywin32` (for Windows)

## Setup

### 1. Create a Virtual Environment

1. Navigate to the directory containing the script.
2. Create a virtual environment:
    ```sh
    python -m venv venv
    ```
3. Activate the virtual environment:
    windows
    ```bash
    venv\Scripts\activate
    ```
    macOS and Linux
    ```bash
    source venv/bin/activate
    ```

### 2. Install Dependencies

1. Install the dependencies listed in requirements.txt:
    ```bash
    pip install -r requirements.txt
    ```

### 3. Create backup-dirs.txt

1. In the same directory as the script, create a file named backup-dirs.txt.
2. List the directories you want to back up, one per line. For example:

    ```txt
    C:\path\to\my-photos
    C:\path\to\my-docs
    C:\path\to\my-games
    /path/to/pics
    /path/to/docs
    /path/to/code
    ```

### 4. Update External Drive Detection

1. Open the script and update the detection logic to replace 'YourExternalDriveLabel' with the actual label of your external drive.

*Usage*

1. Ensure your external hard drive is connected.
2. Run the script:

    ```bash
    python script_name.py
    ```

    This will:
       - Read the directories from backup-dirs.txt.
       - Detect the external hard drive.
       - Create a ZIP file containing the specified folders.
       - Copy the ZIP file to the backup directory on the external hard drive.

*Example Output*

    ```bash
    Created zip file: /path/to/created/zip/backup_20240101_123456.zip
    Copied /path/to/created/zip/backup_20240101_123456.zip to /external/drive/path/backup
    ```
    
*Troubleshooting*

- If the script cannot find the external hard drive, ensure the drive is connected and the label in the script matches the actual drive label.
- If the script encounters permission issues, ensure it has the necessary permissions to read the directories and write to the external drive.