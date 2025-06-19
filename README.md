# WallaMarvel

WallaMarvel is a Marvel superhero explorer app built with SwiftUI, using **Clean Architecture**, **MVVM-C**, **CoreData** for offline support, and **Modularization** via Swift Packages. This app demonstrates a robust architecture ready for production-scale features, testability, and modularization.

---

## Architecture

The app follows a **Clean Architecture** layered approach combined with **MVVM-C** (Model–View–ViewModel–Coordinator) for clear separation of concerns and modularity. Each layer is extracted into its own **Swift Package** for scalability and reusability.

### Layered Structure (Modularized)


```
WallaMarvel
├── App                     # Entry point and lifecycle (WallaMarvelApp)
├── WallaMarvelCore        # Constants, Extensions, Helpers, Network Monitor
├── WallaMarvelDomain      # Entities, UseCases, Repository Protocols
├── WallaMarvelData        # API Client, CoreData Cache, DTOs, Mappers
├── WallaMarvelPresentation
│   ├── Coordinators        # AppCoordinator, HeroesListCoordinator
│   ├── ViewModels          # View logic for list and detail
│   └── Views               # SwiftUI views for UI components
│       ├── HeroesList
│       ├── HeroDetail
│       ├── Components
│       └── Layout (Gradient, Background)
├── Resources               # Assets, fonts, colors, and strings
├── Tests                   # Modular Unit, UI, Integration tests
│   ├── WallaMarvelCoreTests
│   ├── WallaMarvelDomainTests
│   ├── WallaMarvelDataTests
│   ├── WallaMarvelPresentationTests
│   └── WallaMarvelUITests
```


Each module is:
- Fully decoupled
- Testable in isolation
- Built with public interfaces only where needed

---

## ⚙CI Integration

This project includes a lightweight **GitHub Actions** CI setup that performs a **sanity check** on every push and pull request to the `main` branch.

- Displays build status via badge:

  ![iOS CI](https://github.com/FatmaAnwar/WallaMarvel/actions/workflows/ios-ci.yml/badge.svg)
- Selects Xcode 15.0.1 environment
- Removes and resolves Swift Package dependencies
- Workflow path: `.github/workflows/ios-ci.yml`

> Note: This setup currently does not build or test the app. It’s a scaffold for basic validation and can be extended to include full build & test pipelines in the future.

---

## Flow Diagram (MVVM-C + Clean Architecture)

```
AppCoordinator
   │
   └──> HeroesListEntryView (View + Coordinator)
            │
            └──> HeroesListViewModel (logic + state)
                     │
                     └──> FetchCharactersUseCase (business logic)
                              │
                              ├──> CharacterRepository
                              │     ├──> MarvelRemoteDataSource
                              │     └──> CharacterCacheRepository
                              └──> CharacterMapper
```

---

## Features

* SwiftUI **NavigationStack** with typed `NavigationPath`
* Infinite scrolling with smart pagination
* Real-time debounced search
* Live network monitoring and offline detection
* CoreData caching for offline support
* Accessibility support (VoiceOver, identifiers, hints)
* MVVM-C architecture using Coordinators
* Modularized architecture using Swift Packages
* Fully unit tested (ViewModels, UseCases, Repository)

---

## Technologies Used

* SwiftUI (iOS 15+)
* Combine
* CoreData
* Kingfisher (Image Caching)
* XCTest (Unit/UI Testing)
* Swift Packages (Modularization)
* MVVM-C + Clean Architecture

---

## Getting Started

```bash
git clone https://github.com/FatmaAnwar/WallaMarvel.git
open WallaMarvel.xcodeproj
```

Make sure to run on iOS 15.0+.

---

## Screenshots

| Home Grid View         | Hero Detail                |
| ---------------------- | -------------------------- |
| ![Simulator Screenshot - iPhone 14 - 2025-06-19 at 11 03 16](https://github.com/user-attachments/assets/2066ef13-6dd3-44f9-a3d9-e2a75c18668c) | ![Simulator Screenshot - iPhone 14 - 2025-06-19 at 11 03 02](https://github.com/user-attachments/assets/5664586f-6115-4ecc-9c12-831b1e16cf31) |

---

## Demo

https://github.com/user-attachments/assets/7053ffdb-5471-4acb-b77d-426c7190de9c

https://github.com/user-attachments/assets/88bd7412-4ef3-4588-8f88-3a6a069633d5

https://github.com/user-attachments/assets/3751035c-1459-47d8-bd96-06671d7f4cb6
