import os
import subprocess

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
    print("🥊 Setting up Skins Environment...")
    
    target_dir = ".testbed/addons"
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)
        
    # Clone Core
    if not os.path.exists(f"{target_dir}/aerobeat-core"):
        print("  + Cloning Core...")
        subprocess.run(["git", "clone", "https://github.com/AeroBeat-Workouts/aerobeat-core.git", f"{target_dir}/aerobeat-core"])

    print("\n⚠️  ACTION REQUIRED: You must manually clone the Feature you are skinning!")
    print(f"    cd {target_dir}")
    print("    git clone https://github.com/AeroBeat-Workouts/aerobeat-feature-boxing.git (Example)")

    # Symlink Assets
    create_symlink("assets", ".testbed/assets")

if __name__ == "__main__":
    main()