# WallaMarvel

[![iOS CI](https://github.com/FatmaAnwar/WallaMarvel/actions/workflows/ios-ci.yml/badge.svg)](https://github.com/FatmaAnwar/WallaMarvel/actions/workflows/ios-ci.yml)

An iOS application that displays a list of Marvel superheroes. Built with a focus on clean architecture, modern UI, and performance optimization.

---

## Features

* Browse Marvel heroes with images and descriptions
* Beautiful UI with gradient cards and animated lists
* Infinite scrolling with pagination
* MVVM with Clean Architecture
* Offline caching using Core Data
* Real-time network monitoring
* Unit and UI Testing with CI integration
* Accessibility support
* Swift Package Manager integration (Kingfisher)

---

## Architecture

* **Presentation Layer:** SwiftUI Views + ViewModels
* **Domain Layer:** Use Cases + Entities
* **Data Layer:** Repositories + Core Data + Network Layer
* **Coordinator Pattern:** Navigation control for separation of concerns

---

## Tech Stack

* Swift 5.9
* SwiftUI 2 / UIKit (interoperability)
* Combine (in transition to async/await)
* Core Data (for persistent caching)
* Kingfisher (image caching)
* GitHub Actions (CI)
* Xcode 16.2

---

## Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/FatmaAnwar/WallaMarvel.git
   ```
2. Open `WallaMarvel.xcodeproj` in Xcode.
3. Run the app on the latest iOS Simulator.

---

## Tests

* Run unit tests: `Cmd + U` in Xcode
* GitHub Actions CI will run tests automatically on push/pull request to `main`
