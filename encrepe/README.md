# 🔐 encrepe — Secure Offline Credential Manager


> **encrepe** is a lightweight SwiftUI-based credential manager that runs **entirely offline** — no cloud, no tracking, just **AES-encrypted peace of mind**.

---

## 🖼 Features

- 🎨 Clean and minimal SwiftUI interface
- 🔐 AES-GCM 256-bit encryption for all credentials
- 🔑 Unlock with Face ID / Touch ID / Device Passcode
- 🧠 Your passphrase = your key. Lose it, lose everything.
- 📦 Core Data storage — zero plaintext in database
- 📋 Tap to securely copy credentials
- 📵 100% offline — no network access, ever

---

## 🔧 Installation

1. Clone this repo:
   ```bash
   git clone https://github.com/yourname/encrepe.git

2.Open in Xcode:
open encrepe.xcodeproj


3.Build & run on iOS 16+ device or simulator
💡 Tip: Make sure biometrics (Face ID / Touch ID) are enabled on your test device or simulator.


🧠 How It Works

On first launch, you're prompted to set a secure passphrase
This passphrase is used to derive a symmetric encryption key using PBKDF2
The key is stored only in memory — never written to disk
All sensitive fields (username, password) are AES-GCM encrypted
You authenticate with biometrics or passcode before viewing or editing
🔥 If the passphrase is forgotten, there is no recovery. This is intentional for privacy.
🔐 Security Breakdown

Layer    Implementation
🔑 Key Derivation    PBKDF2 + Salt (persisted in Keychain)
🔐 Encryption    AES-GCM (256-bit) via CryptoKit
📁 Storage    Core Data (encrypted values only)
👁 Authentication    Face ID / Touch ID / Passcode
☁️ Network    None. App has no internet access
✅ There are no third-party dependencies. Everything is native Swift.
                                                                                    
                                                                                    

Contributions are welcome! Feel free to:

Open issues for bugs or ideas
Submit pull requests
Fork and customize your own version
If you find this useful, consider starring the repo ⭐️

📝 License

This project is licensed under the MIT License.
Use it, learn from it, modify it — just don’t blame me if you forget your passphrase 😅
