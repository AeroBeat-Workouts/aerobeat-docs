import os
import subprocess
import sys

def create_symlink(src, dst):
    if os.path.exists(dst):
        return
    
    src_abs = os.path.abspath(src)
    dst_abs = os.path.abspath(dst)
    
    print(f"  + Linking {src} -> {dst}")
    try:
        os.symlink(src_abs, dst_abs)
    except OSError:
        # Windows fallback (requires Admin or Developer Mode usually, or use Junction)
        subprocess.run(f'mklink /J "{dst_abs}" "{src_abs}"', shell=True)

def main():
    print("🔧 Setting up Feature Testbed...")
    
    # Features run inside .testbed/
    target_dir = ".testbed/addons"
    
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)
        
    # Clone Feature Core and Content Core into the testbed
    if not os.path.exists(f"{target_dir}/aerobeat-feature-core"):
        print("  + Cloning Feature Core into Testbed...")
        subprocess.run(["git", "clone", "https://github.com/AeroBeat-Workouts/aerobeat-feature-core.git", f"{target_dir}/aerobeat-feature-core"])

    if not os.path.exists(f"{target_dir}/aerobeat-content-core"):
        print("  + Cloning Content Core into Testbed...")
        subprocess.run(["git", "clone", "https://github.com/AeroBeat-Workouts/aerobeat-content-core.git", f"{target_dir}/aerobeat-content-core"])

    # Clone GUT (Required for Testing)
    if not os.path.exists(f"{target_dir}/gut"):
        print("  + Cloning GUT into Testbed...")
        subprocess.run(["git", "clone", "https://github.com/bitwes/Gut.git", f"{target_dir}/gut"])

    # Symlink source only. Repo-local unit tests now live directly under .testbed/tests.
    create_symlink("src", ".testbed/src")

if __name__ == "__main__":
    main()