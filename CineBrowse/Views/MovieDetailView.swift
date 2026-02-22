//
//  MovieDetailView.swift
//  CineBrowse
//
//  Created by Faraz Amjad on 22.02.26.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @State private var viewModel = MovieDetailViewModel()
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                infoSection
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.primaryText)
            }
        }
        .task { await viewModel.loadDetail(movieId: movie.id) }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .tint(AppTheme.accent)
                    .controlSize(.large)
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        ZStack(alignment: .bottomLeading) {
            backdropImage
            posterOverlay
        }
    }

    private var backdropImage: some View {
        AsyncImage(url: movie.backdropURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(16/9, contentMode: .fill)
            case .failure, .empty:
                Rectangle()
                    .fill(AppTheme.placeholder)
                    .aspectRatio(16/9, contentMode: .fill)
                    .overlay {
                        Image(systemName: "film")
                            .font(.largeTitle)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
            @unknown default:
                Rectangle()
                    .fill(AppTheme.placeholder)
                    .aspectRatio(16/9, contentMode: .fill)
            }
        }
        .overlay {
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.0),
                    .init(color: Color.black.opacity(0.3), location: 0.3),
                    .init(color: Color.black.opacity(0.75), location: 0.65),
                    .init(color: Color.black, location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    private var posterOverlay: some View {
        HStack(alignment: .bottom, spacing: 16) {
            // Poster
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(2/3, contentMode: .fit)
                default:
                    Rectangle()
                        .fill(AppTheme.placeholder)
                        .aspectRatio(2/3, contentMode: .fit)
                        .overlay {
                            Image(systemName: "film")
                                .foregroundStyle(AppTheme.secondaryText)
                        }
                }
            }
            .frame(width: 120)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .black.opacity(0.6), radius: 10, y: 4)

            // Title & meta
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.title2.bold())
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color(red: 26/255, green: 26/255, blue: 26/255))
                    .lineLimit(3)

                HStack(spacing: 12) {
                    ratingBadge
                    metaLabel(movie.year)
                    if let runtime = viewModel.detail?.formattedRuntime {
                        metaLabel(runtime)
                    }
                }
            }
            .padding(.bottom, 4)
        }
        .padding()
    }

    private var ratingBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundStyle(AppTheme.accent)
            Text(String(format: "%.1f", movie.voteAverage))
                .fontWeight(.bold)
                .foregroundStyle(.white)
        }
        .font(.subheadline)
    }

    private func metaLabel(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.white.opacity(0.75))
    }

    // MARK: - Info Section

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            if let detail = viewModel.detail {
                genreTags(detail.genres)

                if let tagline = detail.tagline, !tagline.isEmpty {
                    Text("\"\(tagline)\"")
                        .font(.subheadline)
                        .italic()
                        .foregroundStyle(AppTheme.secondaryText)
                }
            }

            overviewSection

            if !viewModel.cast.isEmpty {
                castSection
            }

            Spacer(minLength: 40)
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }

    // MARK: - Genres

    private func genreTags(_ genres: [Genre]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(genres) { genre in
                    Text(genre.name)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .foregroundStyle(AppTheme.accent)
                        .background(
                            Capsule()
                                .fill(AppTheme.accent.opacity(0.12))
                        )
                        .overlay(
                            Capsule()
                                .strokeBorder(AppTheme.accent.opacity(0.25), lineWidth: 1)
                        )
                }
            }
        }
    }

    // MARK: - Overview

    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Overview")

            Text(movie.overview)
                .font(.body)
                .foregroundStyle(AppTheme.secondaryText)
                .lineSpacing(5)
        }
    }

    // MARK: - Cast

    private var castSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle("Cast")

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.cast.prefix(20)) { member in
                        castCard(member)
                    }
                }
            }
        }
    }

    private func castCard(_ member: CastMember) -> some View {
        VStack(spacing: 8) {
            AsyncImage(url: member.profileURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                default:
                    AppTheme.placeholder
                        .overlay {
                            Image(systemName: "person.fill")
                                .font(.title3)
                                .foregroundStyle(AppTheme.secondaryText)
                        }
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .strokeBorder(AppTheme.accent.opacity(0.3), lineWidth: 2)
            )

            VStack(spacing: 2) {
                Text(member.name)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppTheme.primaryText)
                    .lineLimit(1)

                if let character = member.character {
                    Text(character)
                        .font(.caption2)
                        .foregroundStyle(AppTheme.secondaryText)
                        .lineLimit(1)
                }
            }
            .frame(width: 90)
        }
    }

    // MARK: - Helpers

    private func sectionTitle(_ title: String) -> some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 2)
                .fill(AppTheme.accent)
                .frame(width: 3, height: 20)

            Text(title)
                .font(.title3.bold())
                .foregroundStyle(AppTheme.primaryText)
        }
    }
}
