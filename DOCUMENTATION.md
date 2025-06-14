## External APIs and Libraries

### Alamofire, SwiftyJSON
Used for handling all network requests. It simplifies HTTP networking and integrates easily with JSON APIs.

**Why used:**  
Provides a more elegant and robust alternative to `URLSession`, especially useful for multipart requests and response handling.

---

## Project Structure Overview

```
ABZTestTask/
├── ABZTestTaskApp.swift        # Entry point of the SwiftUI App
│
├── API/
|   |-- NetworkManager/
│   |   ├── HTTPManager.swift        # Custom API manager for GET, POST, and multipart upload
│   |   ├── NetworkManager.swift     # responsible for handling API requests, decoding responses into models
│   |   ├── UrlRequest.swift         # Enum for constructing URL endpoints
│   |   ├── NetworkMonitor.swift     # Monitors internet connection status
│   |   └── NetworkSessionManager.swift # Alamofire Session configuration
│   |
|   ├── Models/
│   |   ├── User.swift          
│   |   └── Position.swift      
│ 
├── App/
│   ├── Components/
│   |   ├── HeaderBannerView.swift         # Displays the top view with header text
│   |   ├── NoConnectionView.swift         # UI shown when there is no internet connection
│   |   ├── SuccessOrErrorRegiterView.swift # Shows registration success or error messages
│   |
│   ├── MainTab/
│   │   ├── MainTabView.swift              # Main Tab Bar
│   |
│   ├── SignUp/
│   │   ├── SignUpView.swift               # User registration form
│   │   ├── CustomTextField.swift          # Custom styled text input field
│   │   ├── SignUpViewModel.swift          # Business logic and state management for registration
│   |
│   └── Users/
│       ├── UsersListView.swift            # Displays the list of registered users
│       ├── UserListCell.swift             # UI component for individual user cell
│       ├── UsersListViewModel.swift       # Business logic and state management
│
└── Infrastructure/
|   |-- Font/                    # Font manager with fonts file
|   ├── Assets.xcassets          # App assets
|   └── Localizable.strings      # Localization files
|
├── Extension/

Each module contains its corresponding `View` and `ViewModel`, keeping presentation and business logic separate.
