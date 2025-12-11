# JustFind - Business Discovery App

A Flutter mobile application for discovering and managing local businesses, built with GetX and Clean Architecture.

## Features

### User Features
- 🔐 Authentication (Login, Register, JWT)
- 🏢 Browse businesses by category
- 🔍 Advanced search with filters
- ⭐ Rate and review businesses
- ❤️ Favorites system
- 📍 Location-based search
- 🌙 Dark mode support
- 🌐 Multi-language (English/Arabic)

### Business Owner Features
- ➕ Add and manage businesses
- 📸 Upload business images
- 📊 View business analytics

### Admin Features
- ✅ Approve/reject businesses
- ✅ Moderate reviews
- 📊 System analytics

## Architecture

Clean Architecture with 3 layers:
- **Presentation**: UI, Controllers, Widgets
- **Domain**: Use Cases, Entities, Repository Interfaces
- **Data**: Models, Repository Implementation, Data Sources

## Tech Stack

- **Framework**: Flutter 3.35.4
- **State Management**: GetX
- **Networking**: Dio
- **Local Storage**: GetStorage
- **Maps**: Google Maps
- **Image Loading**: Cached Network Image

## Project Structure

```
lib/
├── app/                    # App configuration
├── core/                   # Core utilities
│   ├── constants/
│   ├── themes/
│   ├── utils/
│   └── errors/
├── data/                   # Data layer
│   ├── models/
│   ├── repositories/
│   └── datasources/
├── domain/                 # Domain layer
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/           # Presentation layer
│   ├── pages/
│   ├── widgets/
│   └── controllers/
└── routes/                 # App routing

```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode
- Backend API running on http://localhost:3000

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

3. Build APK:
```bash
flutter build apk --release
```

## API Configuration

Backend URL: `http://localhost:3000`

Update in `lib/core/constants/api_constants.dart` if needed.

## License

Proprietary
