//
//  ImageLoader.swift
//  Aven
//
//  Created by Armando Gonzalez on 7/17/22.
//


import Combine
//import UIKit
import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private(set) var isLoading = false
    
    private let url: URL
    private var cancellable: AnyCancellable?
    
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    
    init(url: URL) {
        self.url = url
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        guard !isLoading else { return }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.imageProcessingQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
}
