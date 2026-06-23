# 🌿 Plant Doc - Mobile App

A smart mobile application built using **Flutter** to help farmers detect plant diseases and get treatment recommendations instantly.

---

## 📱 About the App

**Plant Doc** is like a **digital doctor for plants** 🌱

Farmers can:
- Scan plant leaves using their phone camera
- Detect diseases using AI
- Get treatment suggestions
- View outbreak locations on a map

This helps prevent crop damage and improves farming efficiency.

---

## 🚀 Features

### 🔍 1. Disease Detection (AI)
- Capture or upload a leaf image
- AI model detects plant disease
- Works **offline** using TensorFlow Lite

### 💊 2. Treatment Suggestions
- Shows disease name
- Provides recommended solutions and treatments

### 🗺️ 3. Outbreak Map
- Uses GPS to mark disease locations
- Helps identify spreading areas

### 📊 4. Dashboard
- Recent scans
- Weather information (API integration)

### 👥 5. Community Feed
- Farmers can share posts
- View others' experiences

### 🧑‍🌾 6. Ask Expert
- Create posts with images
- Get help from community

### 👤 7. User Profile
- Manage user details
- Dark mode support
- Logout functionality

---

## 🛠️ Tech Stack

### Frontend
- Flutter (Android & iOS)

### AI Model
- TensorFlow Lite
- Google Teachable Machine

### Backend
- Firebase Authentication
- Cloud Firestore
- Firebase Storage

### Other Integrations
- Google Maps API
- Weather API
- Camera & Image Picker

---

## 🧠 System Architecture

The app is built using 3 main components:

1. **Frontend (Flutter)**
   - UI screens (Login, Home, Camera, Results)

2. **AI Engine (TensorFlow Lite)**
   - Detects plant diseases from images

3. **Backend (Firebase)**
   - Stores user data and scan history

---

## ⚙️ Installation & Setup

```bash
# Clone the repository
git clone https://github.com/your-username/plant-doc.git

# Navigate to project folder
cd plant-doc

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## 🔑 Firebase Setup

1. Create a Firebase project
2. Enable:
   - Authentication (Email/Password)
   - Firestore Database
   - Storage
3. Add the config file:

```
android/app/google-services.json
```

---

## 📸 How It Works

1. Open camera
2. Capture plant leaf image
3. AI detects disease
4. App shows:
   - Disease name
   - Treatment
5. Location is saved on map

---

## 💡 Tips

- Use Git branches for team collaboration
- Share Firebase config with team
- Add `.tflite` model inside `assets/`

---

## 📌 Future Improvements

- Improve AI accuracy
- Add multi-language support
- Real-time outbreak alerts
- Expert consultation system

---

## 📄 License

This project is for educational purposes only.
