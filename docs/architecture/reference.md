# Directory Structure Reference

### A. The Core Project (`aerobeat-core`)
```
aerobeat-core/
├── contracts/          # Interfaces (AeroInputStrategy)
├── data_types/         # Resources (AeroSessionContext, BeatData)
├── globals/            # Static Consts (AeroConst, AeroEvents)
└── utils/              # Math Helpers (KalmanFilter)
```

### B. A Feature Project (`aerobeat-feat-input`)
```
aerobeat-input-mediapipe-python/
├── python_mediapipe/       # CV Sidecar Code
├── scripts/
│   ├── strategies/     # Logic Implementation
│   │   ├── strategy_mediapipe.gd
│   │   └── strategy_debug.gd
│   └── input_manager.gd
├── .testbed/           # Ignored Ghost Project
└── plugin.cfg
```

### C. The UI Core Project (`aerobeat-ui-core`)
```
aerobeat-ui-core 
├── scripts/ 
│ ├── base/ 
│ │ ├── aero_button_base.gd 
│ │ └── aero_view_base.gd 
│ └── utils/
```

### D. The UI Kit Project (`aerobeat-ui-kit-community`)
```
aerobeat-ui-kit-community/
├── atoms/
│   ├── aero_button/
│   │   ├── AeroButton.tscn       <-- Extends AeroButtonBase
│   │   └── AeroButton_Test.tscn
│   └── aero_slider/ ...
├── molecules/
│   ├── song_card/
│   │   ├── SongCard.tscn         <-- Uses AeroButton + AeroLabel
│   │   └── SongCard_Test.tscn
└── sync_manifest.json            <-- Defines exports
```