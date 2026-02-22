//
//  MovieListViewModel.swift
//  CineBrowse
//
//  Created by Faraz Amjad on 22.02.26.
//

import Foundation

enum MovieSection: String, CaseIterable {
    case popular = "Popular"
    case trending = "Trending"
}

@Observable
final class MovieListViewModel {
    var movies: [Movie] = []
    var selectedSection: MovieSection = .popular
    var isLoading = false
    var errorMessage: String?

    func loadMovies() async {
        isLoading = true
        errorMessage = nil
        do {
            switch selectedSection {
            case .popular:
                movies = try await TMDBService.fetchPopularMovies()
            case .trending:
                movies = try await TMDBService.fetchTrendingMovies()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
