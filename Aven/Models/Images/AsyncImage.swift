//
//  AsyncImage.swift
//  Aven
//
//  Created by Armando Gonzalez on 7/17/22.
//

import SwiftUI

struct AsyncImage: View {
    private enum Constants {
        static let placeholderText = "Loading..."
        static let imageWidth: CGFloat = 50
        static let imageHeight: CGFloat = 50
    }
    
    @StateObject private var loader: ImageLoader
    private let placeholder = Text(Constants.placeholderText)
    private let image: (UIImage) -> Image
    
    init(
        url: URL,
        @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
    ) {
        self.image = image
        self._loader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        self.content
            .onAppear {
                self.loader.load()
            }
    }
    
    private var content: some View {
        Group {
            if let loaderImage = loader.image {
                self.image(loaderImage)
                    .resizable()
                    .frame(width: Constants.imageWidth, height: Constants.imageHeight)
            } else {
                self.placeholder
            }
        }
    }
}
