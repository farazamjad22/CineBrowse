//
//  TMDBService.swift
//  CineBrowse
//
//  Created by Faraz Amjad on 22.02.26.
//

import Foundation

enum TMDBService {
    // MARK: - Replace with your TMDB API key from https://www.themoviedb.org/settings/api
    static let apiKey = "606c4d7867a430a2fc67edf112d6e200"

    private static let baseURL = "https://api.themoviedb.org/3"

    static func fetchPopularMovies() async throws -> [Movie] {
        let url = buildURL(path: "/movie/popular")
        let (data, response) = try await URLSession.shared.data(from: url)
        logResponse(endpoint: "/movie/popular", response: response, data: data)
        return try JSONDecoder().decode(MovieResponse.self, from: data).results
    }

    static func fetchTrendingMovies() async throws -> [Movie] {
        let url = buildURL(path: "/trending/movie/week")
        let (data, response) = try await URLSession.shared.data(from: url)
        logResponse(endpoint: "/trending/movie/week", response: response, data: data)
        return try JSONDecoder().decode(MovieResponse.self, from: data).results
    }

    static func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        let url = buildURL(path: "/movie/\(id)")
        let (data, response) = try await URLSession.shared.data(from: url)
        logResponse(endpoint: "/movie/\(id)", response: response, data: data)
        return try JSONDecoder().decode(MovieDetail.self, from: data)
    }

    static func fetchMovieCredits(id: Int) async throws -> [CastMember] {
        let url = buildURL(path: "/movie/\(id)/credits")
        let (data, response) = try await URLSession.shared.data(from: url)
        logResponse(endpoint: "/movie/\(id)/credits", response: response, data: data)
        return try JSONDecoder().decode(CreditsResponse.self, from: data).cast
    }

    private static func logResponse(endpoint: String, response: URLResponse, data: Data) {
        #if DEBUG
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1

        var prettyJSON: String?
        if let object = try? JSONSerialization.jsonObject(with: data, options: []),
           let prettyData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
           let string = String(data: prettyData, encoding: .utf8) {
            prettyJSON = string
        }

        print("TMDBService [\(endpoint)] - Status: \(statusCode)")
        if let prettyJSON {
            print(prettyJSON)
        } else {
            print("(Response body not JSON, \(data.count) bytes)")
        }
        #endif
    }

    private static func buildURL(path: String, queryItems: [URLQueryItem] = []) -> URL {
        var components = URLComponents(string: baseURL + path)!
        var items = [URLQueryItem(name: "api_key", value: apiKey)]
        items.append(contentsOf: queryItems)
        components.queryItems = items
        return components.url!
    }
}
