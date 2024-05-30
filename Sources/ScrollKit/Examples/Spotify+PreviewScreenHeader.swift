//
//  SpotifyPreviewScreenHeader.swift
//  ScrollKit
//
//  Created by Daniel Saidi on 2023-02-06.
//  Copyright © 2023-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension Spotify {
    
    /// This view mimics a Spotify album screen header.
    struct PreviewScreenHeader: View {
        
        public init(
            info: PreviewInfo,
            headerVisibleRatio: CGFloat = 1
        ) {
            self.info = info
            self.headerVisibleRatio = headerVisibleRatio
        }
        
        public static let height: CGFloat = 280
        
        private var info: PreviewInfo
        private var headerVisibleRatio: CGFloat
        
        public var body: some View {
            ZStack {
                ScrollViewHeaderGradient(info.tintColor, .black)
                ScrollViewHeaderGradient(info.tintColor.opacity(1), info.tintColor.opacity(0))
                    .opacity(1 - headerVisibleRatio)
                cover
            }
        }
    }
}

private extension Spotify.PreviewScreenHeader {

    var cover: some View {
        AsyncImage(
            url: URL(string: info.releaseCoverUrl),
            content: { image in
                image.image?.resizable()
                    .aspectRatio(contentMode: .fit)
            }
        )
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(5)
        .shadow(radius: 10)
        .rotation3DEffect(.degrees(rotationDegrees), axis: (x: 1, y: 0, z: 0))
        .offset(y: verticalOffset)
        .opacity(headerVisibleRatio)
        .padding(.top, 60)
        .padding(.bottom, 20)
        .padding(.horizontal, 20)
    }

    var rotationDegrees: CGFloat {
        guard headerVisibleRatio > 1 else { return 0 }
        let value = 20.0 * (1 - headerVisibleRatio)
        return value.capped(to: -5...0)
    }

    var verticalOffset: CGFloat {
        guard headerVisibleRatio < 1 else { return 0 }
        return 70.0 * (1 - headerVisibleRatio)
    }
}

private extension CGFloat {

    func capped(to range: ClosedRange<Self>) -> Self {
        if self < range.lowerBound { return range.lowerBound }
        if self > range.upperBound { return range.upperBound }
        return self
    }
}

#Preview {

    Spotify.PreviewScreenHeader(info: .anthrax)
        .frame(height: Spotify.PreviewScreenHeader.height)
}
