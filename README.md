# 👨‍💻 Codebase – Flutter BLoC User List App

A Flutter application demonstrating clean architecture using **Cubit (BLoC)**, **Dio** for API calls, and **connectivity_plus** for network awareness. The app fetches users from a REST API and supports features like infinite scroll pagination, search, pull-to-refresh, error handling, and image caching.

---

## 🚀 Features

- ✅ BLoC Cubit state management
- 🌐 API integration with Dio
- 📶 Internet connectivity detection
- 🔁 Infinite scrolling with pagination
- 🔍 Real-time user search by name
- 🔄 Pull to refresh
- 🖼 Cached profile images with loading placeholders
- ❌ No data and error handling UI
- 💡 Clean code architecture

## 🧱 Architecture Overview

The project follows a simple and scalable **Clean Code Architecture**:

lib/
├── core/ # Core utilities (Dio client, connectivity checker)
├── data/ # API services and models
├── logic/ # Business logic with BLoC Cubit
├── presentation/ # UI screens and widgets
└── main.dart # Entry point

## 📦 Packages Used

| Package                | Purpose                                    |
|------------------------|--------------------------------------------|
| `flutter_bloc`         | State management using Cubit               |
| `dio`                  | Networking and API calls                   |
| `cached_network_image` | Image caching and loading                  |
| `connectivity_plus`    | Internet connectivity monitoring           |
| `fluttertoast`         | Display toast messages                     |

## 🔗 API Used

- [https://reqres.in/api/users](https://reqres.in/api/users)

Supports pagination with parameters:
- `?page=1&per_page=10`