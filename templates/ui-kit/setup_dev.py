import os
import subprocess

def main():
    print("🔧 Setting up UI Kit Environment...")
    
    if not os.path.exists("addons"):
        os.makedirs("addons")
        
    # Clone UI Core (Required base logic)
    if not os.path.exists("addons/aerobeat-ui-core"):
        print("  + Cloning UI Core...")
        subprocess.run(["git", "clone", "https://github.com/AeroBeat-Fitness/aerobeat-ui-core.git", "addons/aerobeat-ui-core"])

if __name__ == "__main__":
    main()