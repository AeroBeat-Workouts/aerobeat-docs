import os
import subprocess

def main():
    print("🎨 Setting up Asset Environment...")
    
    # Ensure addons folder exists
    if not os.path.exists("addons"):
        os.makedirs("addons")
        
    # Clone Core (Required for Resource definitions like AeroSkin, AeroSong)
    if not os.path.exists("addons/aerobeat-core"):
        print("  + Cloning Core...")
        subprocess.run(["git", "clone", "https://github.com/AeroBeat-Fitness/aerobeat-core.git", "addons/aerobeat-core"])
    else:
        print("  + Core already exists.")

    print("\n✅ Setup Complete!")
    print("Note: If this asset pack depends on a specific Feature (e.g. Boxing),")
    print("you must manually clone that feature repo into 'addons/' as well.")

if __name__ == "__main__":
    main()