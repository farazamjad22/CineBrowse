//
//  ImageLoader.swift
//  CineBrowse
//
//  Created by Faraz Amjad on 22.02.26.
//

import SwiftUI

// MARK: - Image Loader

@Observable
final class ImageLoader {
    var image: UIImage?
    var isLoading = false
    var hasFailed = false

    private static let cache = NSCache<NSURL, UIImage>()
    private static let maxRetries = 3

    /// Clears both the in-memory NSCache and the URL-level disk cache.
    static func clearCache() {
        cache.removeAllObjects()
        URLCache.shared.removeAllCachedResponses()
    }

    func load(url: URL?) async {
        guard let url else {
            image = nil
            isLoading = false
            hasFailed = true
            return
        }

        // Check in-memory cache first
        if let cached = Self.cache.object(forKey: url as NSURL) {
            image = cached
            isLoading = false
            hasFailed = false
            return
        }

        // Reset state for a fresh load
        image = nil
        isLoading = true
        hasFailed = false

        for attempt in 1...Self.maxRetries {
            guard !Task.isCancelled else { return }

            do {
                let request = URLRequest(
                    url: url,
                    cachePolicy: .reloadRevalidatingCacheData
                )
                let (data, response) = try await URLSession.shared.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode),
                      let uiImage = UIImage(data: data) else {
                    throw URLError(.badServerResponse)
                }

                Self.cache.setObject(uiImage, forKey: url as NSURL)
                image = uiImage
                isLoading = false
                return

            } catch is CancellationError {
                return
            } catch {
                if attempt < Self.maxRetries {
                    try? await Task.sleep(for: .milliseconds(500 * attempt))
                }
            }
        }

        isLoading = false
        hasFailed = true
    }
}

// MARK: - Cached Image View

struct CachedImageView<Content: View, Placeholder: View>: View {
    let url: URL?
    @ViewBuilder let content: (Image) -> Content
    @ViewBuilder let placeholder: () -> Placeholder

    @State private var loader = ImageLoader()

    var body: some View {
        Group {
            if let uiImage = loader.image {
                content(Image(uiImage: uiImage))
            } else if loader.isLoading {
                placeholder()
                    .overlay { ShimmerOverlay() }
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            await loader.load(url: url)
        }
    }
}

// MARK: - Shimmer Effect

struct ShimmerOverlay: View {
    @State private var startPoint: UnitPoint = .init(x: -1.5, y: 0.5)
    @State private var endPoint: UnitPoint = .init(x: -0.5, y: 0.5)

    var body: some View {
        LinearGradient(
            colors: [.clear, .white.opacity(0.12), .clear],
            startPoint: startPoint,
            endPoint: endPoint
        )
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                startPoint = .init(x: 1.0, y: 0.5)
                endPoint = .init(x: 2.5, y: 0.5)
            }
        }
    }
}
