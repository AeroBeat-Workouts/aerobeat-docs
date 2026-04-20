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
        subprocess.run(f'mklink /J "{dst_abs}" "{src_abs}"', shell=True)

def main():
    print("🎨 Setting up Asset Environment...")
    
    # Assets run inside .testbed/
    target_dir = ".testbed/addons"
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)
        
    # Clone Asset Core (Required for shared asset-side resource definitions)
    if not os.path.exists(f"{target_dir}/aerobeat-asset-core"):
        print("  + Cloning Asset Core...")
        subprocess.run(["git", "clone", "https://github.com/AeroBeat-Workouts/aerobeat-asset-core.git", f"{target_dir}/aerobeat-asset-core"])
    else:
        print("  + Asset Core already exists.")

    print("\n✅ Setup Complete!")
    print("Note: If this asset pack depends on a specific Feature (e.g. Boxing),")
    print("you must manually clone that feature repo into 'addons/' as well.")

    # Symlink Assets
    create_symlink("assets", ".testbed/assets")

if __name__ == "__main__":
    main()