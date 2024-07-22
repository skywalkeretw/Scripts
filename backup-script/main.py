import os
import zipfile
import shutil
from datetime import datetime
import platform

def get_external_drive_path():
    """
    Detects the path of the external hard drive.

    Returns:
    str: Path to the external hard drive, or None if not found.
    """
    if os.name == 'nt':  # Windows
        import win32api
        drives = win32api.GetLogicalDriveStrings().split('\000')[:-1]
        for drive in drives:
            try:
                if win32api.GetVolumeInformation(drive)[0] == 'YourExternalDriveLabel':
                    return drive
            except Exception:
                continue
    else:  # macOS and Linux
        import psutil
        partitions = psutil.disk_partitions()
        for partition in partitions:
            if 'YourExternalDriveLabel' in partition.device:
                return partition.mountpoint
    
    return None

def create_zip(folder_paths, zip_name):
    """
    Creates a zip file containing the specified folders.

    Parameters:
    folder_paths (list): List of folder paths to include in the zip.
    zip_name (str): Name of the resulting zip file.

    Returns:
    str: Path to the created zip file.
    """
    with zipfile.ZipFile(zip_name, 'w', zipfile.ZIP_DEFLATED) as zipf:
        for folder in folder_paths:
            for root, dirs, files in os.walk(folder):
                for file in files:
                    file_path = os.path.join(root, file)
                    arcname = os.path.relpath(file_path, os.path.join(folder, '..'))
                    zipf.write(file_path, arcname)
    return os.path.abspath(zip_name)

def copy_to_external(zip_path, external_drive_path):
    """
    Copies the zip file to a specified folder on an external hard drive.

    Parameters:
    zip_path (str): Path to the zip file.
    external_drive_path (str): Path to the destination folder on the external hard drive.
    """
    if not os.path.exists(external_drive_path):
        os.makedirs(external_drive_path)
    shutil.copy(zip_path, external_drive_path)
    print(f"Copied {zip_path} to {external_drive_path}")

def read_backup_dirs(file_path):
    """
    Reads the list of directories to back up from a file.

    Parameters:
    file_path (str): Path to the file containing the list of directories.

    Returns:
    list: List of directory paths.
    """
    with open(file_path, 'r') as file:
        dirs = file.read().splitlines()
    return [d for d in dirs if d.strip()]

def main():
    # Determine the directory of the current script
    script_dir = os.path.dirname(os.path.abspath(__file__))

    # Path to the backup-dirs.txt file
    backup_dirs_file = os.path.join(script_dir, 'backup-dirs.txt')

    # Read the list of directories to include in the zip file
    folders_to_zip = read_backup_dirs(backup_dirs_file)

    # Name of the zip file with a timestamp
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    zip_filename = f"backup_{timestamp}.zip"

    # Detect the external hard drive
    external_drive = get_external_drive_path()
    if not external_drive:
        print("External hard drive not found. Please ensure it is connected and try again.")
        return

    # Path to the backup folder on the external hard drive
    external_drive_folder = os.path.join(external_drive, 'backup')

    # Create the zip file
    zip_file_path = create_zip(folders_to_zip, zip_filename)
    print(f"Created zip file: {zip_file_path}")

    # Copy the zip file to the external hard drive
    copy_to_external(zip_file_path, external_drive_folder)

if __name__ == "__main__":
    main()
