//
//  MovieDetailViewModel.swift
//  CineBrowse
//
//  Created by Faraz Amjad on 22.02.26.
//

import Foundation

@Observable
final class MovieDetailViewModel {
    var detail: MovieDetail?
    var cast: [CastMember] = []
    var isLoading = false
    var errorMessage: String?

    func loadDetail(movieId: Int) async {
        isLoading = true
        errorMessage = nil
        do {
            async let detailRequest = TMDBService.fetchMovieDetail(id: movieId)
            async let creditsRequest = TMDBService.fetchMovieCredits(id: movieId)
            detail = try await detailRequest
            cast = try await creditsRequest
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
