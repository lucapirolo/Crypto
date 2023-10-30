//
//  CryptoImageView.swift
//  Crypto
//
//  Created by Luca Pirolo on 30/10/2023.
//

import SwiftUI

struct CryptoImageView: View {
    let imageURL: String
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    let isResizable: Bool
    let placeholderImageName: String?

    init(imageURL: String, width: CGFloat = 25, height: CGFloat = 25, cornerRadius: CGFloat = 8, isResizable: Bool = true, placeholderImageName: String? = "photo") {
        self.imageURL = imageURL
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.isResizable = isResizable
        self.placeholderImageName = placeholderImageName
    }

    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty:
                placeholderView.frame(width: width, height: height).cornerRadius(cornerRadius)
            case .success(let image):
                let resizedImage = isResizable ? image.resizable() : image
                resizedImage.aspectRatio(contentMode: .fill).transition(.opacity)
            case .failure:
                placeholderView.frame(width: width, height: height).cornerRadius(cornerRadius)
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: width, height: height)
    }

    private var placeholderView: some View {
        if let imageName = placeholderImageName {
            return AnyView(Image(systemName: imageName))
        } else {
            return AnyView(Color.secondary)
        }
    }
}
