# ABZTestTask

ABZTestTask is a SwiftUI-based iOS application for user registration and listing using a public API provided by [abz.agency](https://frontend-test-assignment-api.abz.agency/). The project emphasizes clean architecture, modular structure, and reusability.

---

## ⚙️ Configuration Parameters

No special configuration files are required.

However, make sure that:
- You are using **Xcode 15+**
- The deployment target is set to **iOS 15.0 or higher**
- You are running the app on a simulator or device with photo library and camera permissions enabled

---

## 📦 Dependencies

This project uses the following third-party libraries:

| Library         | Purpose                          | Installation Method         |
|------------------|----------------------------------|-----------------------------|
| **Alamofire**     | For HTTP networking              | Swift Package Manager       |
| **SwiftyJSON**    | Easier JSON parsing              | Swift Package Manager       |

### How to install

1. Open your project in **Xcode**
2. Go to `File > Add Packages`
3. Add the following URLs:
   - Alamofire: `https://github.com/Alamofire/Alamofire`
   - SwiftyJSON: `https://github.com/SwiftyJSON/SwiftyJSON`
4. Choose version rule: "Up to Next Major"
5. Add the packages to your target

---

## 🧩 Common Issues & Troubleshooting

| Issue | Solution |
|-------|----------|
| **Users not displayed** | Make sure you're using a valid `/token` before calling `/users`. Tokens are valid for 40 minutes. |
| **Registration fails** | Ensure all fields are valid. Phone must begin with `+380`, and image must be JPEG ≤ 5MB. |
| **Camera crashes** | Only real devices support camera. Make sure the app has permission in system settings. |
| **Keyboard hides fields** | The scroll view automatically adjusts content, but this behavior may vary on custom tab bar layouts. |

---

## 🚀 Build & Run Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/ABZTestTask.git
   ```
2. Open the project in Xcode:
   ```
   open ABZTestTask.xcodeproj
   ```
3. Select a simulator or real device
4. Build and run with `Cmd + R`
