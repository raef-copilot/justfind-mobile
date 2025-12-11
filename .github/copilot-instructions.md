# Flutter GetX JustFind App - Workspace Instructions

## Project Overview
Flutter mobile app with GetX and clean architecture for JustFind (Justdial clone).

## Progress Tracking
- [x] Create copilot-instructions.md
- [x] Get Flutter project setup info
- [x] Create Flutter project structure
- [x] Create pubspec.yaml with dependencies
- [x] Set up core layer
- [x] Set up data layer
- [x] Set up domain layer
- [x] Set up presentation layer
- [x] Create routes and navigation
- [x] Create main.dart and app config
- [x] Install required dependencies
- [ ] Fix compilation errors (296 issues - mostly type mismatches)
- [ ] Test on Android/iOS emulator

## Architecture
Clean Architecture with 3 layers:
- **Data Layer**: Models, repositories implementation, data sources
- **Domain Layer**: Entities, repository interfaces, use cases
- **Presentation Layer**: Pages, widgets, GetX controllers

## Tech Stack
- Flutter SDK (latest stable)
- GetX (state management, routing, DI)
- Dio (HTTP client)
- GetStorage (local storage)
- Cached Network Image
- Image Picker
- Google Maps

## Backend API
- Base URL: http://localhost:3000
- JWT authentication
- Role-based access: admin, business_owner, customer
