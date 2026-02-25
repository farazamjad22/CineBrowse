# CineBrowse

A native iOS movie discovery app built with SwiftUI that lets you browse popular and trending movies in real time using The Movie Database (TMDB) API. Features a polished dark/light mode UI, detailed movie pages with cast info, and smooth animations throughout.

## Features

- **Popular & Trending Movies** - Toggle between popular and trending (weekly) movies with an animated pill-shaped selector
- **Movie Details** - Tap any movie to see its full details including overview, tagline, runtime, genres, rating, and release year
- **Cast Section** - Horizontally scrollable cast carousel showing actor photos and names (up to 20 members)
- **Dark / Light Mode** - Persistent theme toggle with smooth transition animations, stored across sessions
- **Pull to Refresh** - Swipe down to refresh the movie listings
- **Image Caching** - In-memory and disk caching with shimmer loading effects and retry logic (up to 3 attempts)
- **Error Handling** - User-friendly error messages with retry buttons when network requests fail

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Language** | Swift 5.9+ |
| **UI Framework** | SwiftUI |
| **Architecture** | MVVM with `@Observable` |
| **Networking** | URLSession + async/await |
| **API** | [TMDB (The Movie Database)](https://www.themoviedb.org/) |
| **Min Deployment** | iOS 26.0 |
| **Dependencies** | None - 100% native Apple frameworks |

## Project Structure

```
CineBrowse/
├── CineBrowseApp.swift            # App entry point
├── ContentView.swift              # Root view with theme toggle logic
├── Models/
│   └── Movie.swift                # Movie, MovieDetail, Genre, CastMember models
├── Services/
│   └── TMDBService.swift          # TMDB API networking layer
├── Theme/
│   └── AppTheme.swift             # Centralized color system (dark/light)
├── ViewModels/
│   ├── MovieListViewModel.swift   # Home screen state management
│   └── MovieDetailViewModel.swift # Detail screen state management
├── Views/
│   ├── HomeView.swift             # Main grid view with section toggle
│   ├── MovieCardView.swift        # Movie poster card component
│   ├── MovieDetailView.swift      # Full movie detail screen
│   └── CachedImageView.swift      # Image loader with caching & shimmer
└── Assets.xcassets/               # App icons and color assets
```

## Getting Started

### Prerequisites

- Xcode 15.0 or later
- iOS 26.0+ simulator or device

### Setup

1. Clone the repository
   ```bash
   git clone https://github.com/farazamjad22/CineBrowse-iOS-App.git
   cd CineBrowse
   ```

2. Open in Xcode
   ```bash
   open CineBrowse.xcodeproj
   ```

3. **Add your TMDB API key** - Get a free API key from [themoviedb.org](https://www.themoviedb.org/settings/api) and update it in `CineBrowse/Services/TMDBService.swift`

4. Select a simulator or device and hit **Run** (`Cmd + R`)

No CocoaPods, SPM packages, or any other dependency installation required.

## Architecture

The app follows the **MVVM** pattern:

- **Models** - Codable structs mapping directly to TMDB API responses (`Movie`, `MovieDetail`, `Genre`, `CastMember`)
- **ViewModels** - `@Observable` classes that manage state and API calls. Movie detail fetches (metadata + credits) run concurrently using `async let`
- **Views** - Declarative SwiftUI views with clean separation from business logic
- **Services** - A single `TMDBService` handles all API communication with structured error handling and debug logging

## API Endpoints Used

| Endpoint | Description |
|----------|-------------|
| `/movie/popular` | Fetches currently popular movies |
| `/trending/movie/week` | Fetches movies trending this week |
| `/movie/{id}` | Fetches full movie details |
| `/movie/{id}/credits` | Fetches cast and crew info |

## Theme System

The app uses a centralized `AppTheme` with two carefully crafted color palettes:

- **Dark Mode** - Deep navy-black backgrounds with cool blue-gray accents
- **Light Mode** - Warm cream backgrounds with clean white cards
- **Accent Color** - A bold red (#E50914) used across both themes for ratings, borders, and highlights

Theme preference is persisted with `@AppStorage` and applies instantly with a smooth animation.

## Screenshots

<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-22 at 20 38 19" src="https://github.com/user-attachments/assets/c0cc0135-1754-4f4d-8dad-ec8e360b2701" />
<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-22 at 20 38 51" src="https://github.com/user-attachments/assets/1937d3dc-a988-4375-9b2f-58cb7493a56d" />
<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-22 at 20 39 53" src="https://github.com/user-attachments/assets/df722cd2-4368-4749-abd1-538bb60eb697" />
<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-22 at 20 39 36" src="https://github.com/user-attachments/assets/de88cd12-ac32-43f8-b107-6e788acc5d0d" />
