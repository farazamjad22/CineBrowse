//
//  HomeView.swift
//  CineBrowse
//
//  Created by Faraz Amjad on 22.02.26.
//

import SwiftUI

struct HomeView: View {
    @Binding var isDarkMode: Bool
    @State private var viewModel = MovieListViewModel()
    @Namespace private var animation

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Fixed header area
                VStack(spacing: 16) {
                    headerBar
                    pillToggle
                }
                .padding(.top, 12)
                .padding(.bottom, 16)

                // Scrollable movie grid only
                ScrollView {
                    movieGrid
                        .padding(.top, 20)
                }
                .refreshable {
                    await viewModel.loadMovies()
                }
            }
            .background(AppTheme.background.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
            .task(id: viewModel.selectedSection) {
                await viewModel.loadMovies()
            }
            .overlay {
                if viewModel.isLoading && viewModel.movies.isEmpty {
                    ProgressView()
                        .tint(AppTheme.accent)
                        .controlSize(.large)
                }
                if let error = viewModel.errorMessage, viewModel.movies.isEmpty {
                    errorView(error)
                }
            }
        }
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 6) {
                Text("CineBrowse")
                    .font(.largeTitle.bold())
                    .foregroundStyle(AppTheme.primaryText)

                RoundedRectangle(cornerRadius: 2)
                    .fill(AppTheme.accent)
                    .frame(width: 40, height: 3)
            }

            Spacer()

            themeToggle
        }
        .padding(.horizontal)
    }

    // MARK: - Theme Toggle

    private var themeToggle: some View {
        HStack(spacing: 8) {
            Image(systemName: isDarkMode ? "moon.stars.fill" : "sun.max.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(isDarkMode ? .indigo : .orange)
                .contentTransition(.symbolEffect(.replace))
                .frame(width: 20)

            Toggle("", isOn: $isDarkMode)
                .toggleStyle(.switch)
                .tint(AppTheme.accent)
                .labelsHidden()
                .scaleEffect(0.85, anchor: .trailing)
        }
    }

    // MARK: - Pill Toggle

    private var pillToggle: some View {
        HStack(spacing: 0) {
            ForEach(MovieSection.allCases, id: \.self) { section in
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        viewModel.selectedSection = section
                    }
                } label: {
                    Text(section.rawValue)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(
                            viewModel.selectedSection == section
                                ? .white
                                : AppTheme.secondaryText
                        )
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background {
                            if viewModel.selectedSection == section {
                                Capsule()
                                    .fill(AppTheme.accent)
                                    .matchedGeometryEffect(id: "pill", in: animation)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(Capsule().fill(AppTheme.cardBackground))
        .padding(.horizontal)
    }

    // MARK: - Movie Grid

    private var movieGrid: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(viewModel.movies) { movie in
                NavigationLink(value: movie) {
                    MovieCardView(movie: movie)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }

    // MARK: - Error

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundStyle(AppTheme.accent)

            Text("Something went wrong")
                .font(.headline)
                .foregroundStyle(AppTheme.primaryText)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button {
                Task { await viewModel.loadMovies() }
            } label: {
                Text("Retry")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(AppTheme.accent))
            }
        }
    }
}

#Preview {
    @Previewable @State var isDark = true
    HomeView(isDarkMode: $isDark)
        .preferredColorScheme(.dark)
}
