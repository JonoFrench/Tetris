//
//  StarBurstView.swift
//  Tetris
//
//  Created by Jonathan French on 14.11.26.
//


import SwiftUI

struct StarBurstView: View {
    let trigger: Int

    private let starImages = [
        "Star1", "Star2", "Star3", "Star4"
    ]

    private let starCount = 8
    private let duration = 1.0

    @State private var startTime: Date?
    @State private var stars: [Star] = []

    // Normalised position across the screen
    @State private var origin = CGPoint(x: 0.5, y: 0.5)

    struct Star: Identifiable {
        let id = UUID()
        let imageName: String
        let angle: Double
        let distance: CGFloat
        let size: CGFloat
        let rotation: Double
        let delay: Double
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            let elapsed = startTime.map {
                timeline.date.timeIntervalSince($0)
            } ?? 0

            let progress = min(max(elapsed / duration, 0), 1)

            GeometryReader { geo in
                ZStack {
                    ForEach(stars) { star in
                        starView(
                            star,
                            progress: progress,
                            size: geo.size
                        )
                    }
                }
            }
        }
        .allowsHitTesting(false)
        .onChange(of: trigger) {
            startBurst()
        }
        .task {
            while !Task.isCancelled {
                startBurst()

                let delay = Double.random(in: 1.5...4.0)

                do {
                    try await Task.sleep(
                        for: .seconds(delay)
                    )
                } catch {
                    break
                }
            }
        }
    }

    @MainActor
    private func startBurst() {
        // Pick a random point, avoiding the very edges
        origin = CGPoint(
            x: CGFloat.random(in: 0.12...0.88),
            y: CGFloat.random(in: 0.12...0.88)
        )

        stars = (0..<starCount).map { _ in
            Star(
                imageName: starImages.randomElement()!,
                angle: Double.random(in: 0...(2 * .pi)),
                distance: CGFloat.random(in: 50...110),
                size: CGFloat.random(in: 16...30),
                rotation: Double.random(in: -360...360),
                delay: Double.random(in: 0...0.15)
            )
        }

        startTime = Date()
    }

    @ViewBuilder
    private func starView(
        _ star: Star,
        progress: Double,
        size: CGSize
    ) -> some View {
        let localProgress = min(
            max(
                (progress - star.delay) / (1 - star.delay),
                0
            ),
            1
        )

        let movement = 1 - pow(1 - localProgress, 2)

        let x = size.width * origin.x
            + CGFloat(cos(star.angle))
            * star.distance
            * movement

        let y = size.height * origin.y
            + CGFloat(sin(star.angle))
            * star.distance
            * movement

        let opacity = 1 - localProgress
        let scale = 0.4 + (0.6 * (1 - localProgress))

        Image(star.imageName)
            .resizable()
            .scaledToFit()
            .frame(
                width: star.size,
                height: star.size
            )
            .scaleEffect(scale)
            .rotationEffect(
                .degrees(star.rotation * localProgress)
            )
            .opacity(opacity)
            .position(x: x, y: y)
    }
}

