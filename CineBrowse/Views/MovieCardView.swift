//
//  MovieCardView.swift
//  CineBrowse
//
//  Created by Faraz Amjad on 22.02.26.
//

import SwiftUI

struct MovieCardView: View {
    let movie: Movie

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            posterImage
            gradientOverlay
            cardInfo
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: AppTheme.cardShadow, radius: 8, y: 4)
    }

    // MARK: - Poster

    private var posterImage: some View {
        AsyncImage(url: movie.posterURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(2/3, contentMode: .fill)
            case .failure:
                posterPlaceholder(systemName: "photo.badge.exclamationmark")
            case .empty:
                posterPlaceholder(systemName: "film")
                    .overlay {
                        ProgressView()
                            .tint(AppTheme.secondaryText)
                    }
            @unknown default:
                posterPlaceholder(systemName: "film")
            }
        }
    }

    private func posterPlaceholder(systemName: String) -> some View {
        Rectangle()
            .fill(AppTheme.placeholder)
            .aspectRatio(2/3, contentMode: .fill)
            .overlay {
                Image(systemName: systemName)
                    .font(.largeTitle)
                    .foregroundStyle(AppTheme.secondaryText)
            }
    }

    // MARK: - Gradient Overlay (purple-to-black in dark, standard in light)

    private var gradientOverlay: some View {
        LinearGradient(
            stops: [
                .init(color: .clear, location: 0.35),
                .init(color: AppTheme.cardGradientStart.opacity(0.6), location: 0.6),
                .init(color: AppTheme.cardGradientEnd.opacity(0.92), location: 1.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .aspectRatio(2/3, contentMode: .fill)
    }

    // MARK: - Info Overlay

    private var cardInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(movie.title)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundStyle(AppTheme.accent)
                Text(String(format: "%.1f", movie.voteAverage))
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.9))
            }
            .font(.caption)
        }
        .padding(10)
    }
}
