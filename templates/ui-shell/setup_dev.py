import os
import subprocess

def main():
    print("🔧 Setting up UI Shell Environment...")
    
    if not os.path.exists("addons"):
        os.makedirs("addons")
        
    # Clone Core (Required for Contracts)
    if not os.path.exists("addons/aerobeat-core"):
        print("  + Cloning Core...")
        subprocess.run(["git", "clone", "https://github.com/AeroBeat-Fitness/aerobeat-core.git", "addons/aerobeat-core"])

if __name__ == "__main__":
    main()