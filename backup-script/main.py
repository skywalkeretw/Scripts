import os
import zipfile
import shutil
from datetime import datetime
import platform
import json
import tkinter as tk
from tkinter import messagebox


def get_external_drive_path(backup_drive):
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
                # win32api.GetVolumeInformation(drive)[0] additional info about the drive
                if drive == backup_drive:
                    return drive
            except Exception:
                continue
    else:  # macOS and Linux
        import psutil
        partitions = psutil.disk_partitions()
        for partition in partitions:
            if backup_drive in partition.device:
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
    Copies the zip file to a specified folder on an external hard drive and deletes the local zip file after copying.

    Parameters:
    zip_path (str): Path to the zip file.
    external_drive_path (str): Path to the destination folder on the external hard drive.
    """
    try:
        if not os.path.exists(external_drive_path):
            os.makedirs(external_drive_path)
        shutil.copy(zip_path, external_drive_path)
        print(f"===> Copied {zip_path} to {external_drive_path}")
        
        # Delete the local zip file after successful copy
        os.remove(zip_path)
        print(f"===> Deleted local zip file: {zip_path}")
        return os.path.join(external_drive_path, os.path.basename(zip_path))

    except Exception as e:
        print(f"An error occurred: {e}")
    
    return ""


def read_config(file_path):
    """
    Reads a JSON configuration file and returns it as a dictionary.

    :param file_path: Path to the JSON file.
    :return: Dictionary containing the configuration.
    """
    with open(file_path, 'r') as file:
        config = json.load(file)
    return config


def show_completion_alert(external_file_path):
    """
    Displays a completion alert using tkinter.
    """
    root = tk.Tk()
    root.withdraw()
    messagebox.showinfo("Completion Alert", f"Backup {external_file_path} saved successfully!")
    root.destroy()

def main():
    # Determine the directory of the current script
    script_dir = os.path.dirname(os.path.abspath(__file__))
    print(f"===> Script Dir: {script_dir}")

    # Path to the backup-dirs.txt file
    backup_dirs_file = os.path.join(script_dir, 'backup-conf.json')
    print(f"===> Absolute Backup config file: {backup_dirs_file}")

    # Read the list of directories to include in the zip file
    config_data = read_config(backup_dirs_file)
    print(f"===> Backup Drive: {config_data['drive']}")
    print(f"===> Folders: {", ".join(config_data['folders'])}")

    # Name of the zip file with a timestamp
    timestamp = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
    zip_filename = f"backup_{timestamp}.zip"
    print(f"===> Backup filename {zip_filename}")

    # Detect the external hard drive
    external_drive = get_external_drive_path(config_data["drive"])
    if not external_drive:
        print("External hard drive not found. Please ensure it is connected and try again.")
        return

    # Path to the backup folder on the external hard drive
    external_drive_folder = os.path.join(external_drive, config_data["backup-folder"])
    if not os.path.exists(external_drive_folder):
        # Create all missing folders
        os.makedirs(external_drive_folder)
        print(f"===> Created the folder: {external_drive_folder}")
    else:
        print(f"===> Saving Backup to: {external_drive_folder}")

    # Create the zip file
    zip_file_path = create_zip(config_data['folders'], zip_filename)
    print(f"===> Created zip file: {zip_file_path}")

    # Copy the zip file to the external hard drive
    external_file_path = copy_to_external(zip_file_path, external_drive_folder)
    print(f"===> Backup {zip_file_path} saved to Harddrive {external_drive}")
    show_completion_alert(external_file_path)


if __name__ == "__main__":
    main()
