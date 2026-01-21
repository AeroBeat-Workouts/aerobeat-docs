import os
import subprocess

def main():
    print("🔧 Setting up Feature Testbed...")
    
    # Features run inside .testbed/
    target_dir = ".testbed/addons"
    
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)
        
    # Clone Core into the testbed
    if not os.path.exists(f"{target_dir}/aerobeat-core"):
        print("  + Cloning Core into Testbed...")
        subprocess.run(["git", "clone", "https://github.com/AeroBeat-Fitness/aerobeat-core.git", f"{target_dir}/aerobeat-core"])

if __name__ == "__main__":
    main()