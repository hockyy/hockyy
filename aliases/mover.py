import os
import shutil

def move_files_to_current():
    current_dir = os.getcwd()
    
    # Walk through all directories and subdirectories
    for root, dirs, files in os.walk(current_dir, topdown=False):
        for name in files:
            # Get the full source path
            source = os.path.join(root, name)
            
            # Skip if the file is already in the current directory
            if os.path.dirname(source) == current_dir:
                continue
            
            # Create new filename
            rel_path = os.path.relpath(source, current_dir)
            new_name = rel_path.replace(os.sep, '_')
            destination = os.path.join(current_dir, new_name)
            
            # Handle duplicate filenames
            counter = 1
            base, ext = os.path.splitext(destination)
            while os.path.exists(destination):
                destination = f"{base}_{counter}{ext}"
                counter += 1
            
            # Move the file
            try:
                shutil.move(source, destination)
                print(f"Moved: {rel_path} -> {os.path.basename(destination)}")
            except Exception as e:
                print(f"Error moving {rel_path}: {e}")

if __name__ == "__main__":
    move_files_to_current()