import os

# Mapping of local documentation paths to their GitHub repositories
PLACEHOLDERS = {
    "docs/api/assembly/community": {
        "title": "Assembly (Community)",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-assembly-community"
    },
    "docs/api/assets/prototypes": {
        "title": "Prototype Assets",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-asset-prototypes"
    },
    "docs/api/core": {
        "title": "Core Contracts",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-core"
    },
    "docs/api/features/boxing": {
        "title": "Boxing Feature",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-feature-boxing"
    },
    "docs/api/features/dance": {
        "title": "Dance Feature",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-feature-dance"
    },
     "docs/api/features/flow": {
        "title": "Flow Feature",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-feature-flow"
    },
     "docs/api/features/step": {
        "title": "Step Feature",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-feature-step"
    },
    "docs/api/inputs/gamepad": {
        "title": "Gamepad Input",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-input-gamepad"
    },
    "docs/api/inputs/keyboard": {
        "title": "Keyboard Input",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-input-keyboard"
    },
    "docs/api/inputs/mouse": {
        "title": "Mouse Input",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-input-mouse"
    },
    "docs/api/inputs/touch": {
        "title": "Touch Input",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-input-touch"
    },
    "docs/api/inputs/joycon-hid": {
        "title": "Joycon Input",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-input-joycon-hid"
    },
    "docs/api/inputs/keyboard": {
        "title": "Keyboard Input",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-input-keyboard"
    },
    "docs/api/inputs/mediapipe_native": {
        "title": "MediaPipe Native Input",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-input-mediapipe-native"
    },
    "docs/api/inputs/mediapipe_python": {
        "title": "MediaPipe Python Input",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-input-mediapipe-python"
    },
    "docs/api/inputs/mouse": {
        "title": "Mouse Input",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-input-mouse"
    },
    "docs/api/inputs/touch": {
        "title": "Touch Input",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-input-touch"
    },
    "docs/api/inputs/xr": {
        "title": "XR Input",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-input-xr"
    },
    "docs/api/tools/api": {
        "title": "Backend Api",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-tool-api"
    },
    "docs/api/tools/settings": {
        "title": "Athlete Settings",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-tool-settings"
    },
    "docs/api/ui/core": {
        "title": "UI Core",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-ui-core"
    },
    "docs/api/ui/kit-community": {
        "title": "UI-Kit Community",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-ui-kit-community"
    },
    "docs/api/ui/shell-desktop-community": {
        "title": "UI-Shell Desktop Community",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-ui-shell-desktop-community"
    },
    "docs/api/ui/shell-mobile-community": {
        "title": "UI-Shell Mobile Community",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-ui-shell-mobile-community"
    },
    "docs/api/ui/shell-web-community": {
        "title": "UI-Shell Web Community",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-ui-shell-web-community"
    },
    "docs/api/ui/shell-xr-community": {
        "title": "UI-Shell XR Community",
        "repo": "https://github.com/AeroBeat-Workouts/aerobeat-ui-shell-xr-community"
    }
}

def main():
    print("Checking for missing documentation placeholders...")
    for path, data in PLACEHOLDERS.items():
        # Ensure directory exists
        os.makedirs(path, exist_ok=True)
        
        index_file = os.path.join(path, "index.md")
        if not os.path.exists(index_file):
            print(f"  + Creating placeholder for: {data['title']}")
            with open(index_file, "w", encoding="utf-8") as f:
                f.write(f"# {data['title']}\n\n")
                f.write("🚧 **Work In Progress**\n\n")
                f.write("This module has not been documented yet.\n\n")
                f.write(f"View the source code on GitHub: [{data['repo']}]({data['repo']})\n")

if __name__ == "__main__":
    main()