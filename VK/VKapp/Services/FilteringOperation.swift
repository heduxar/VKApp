//
//  FilteringOperation.swift
//  VKapp
//
//  Created by Юрий Султанов on 01.10.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

protocol FilteredImageProvider {
    var outputImage: UIImage? { get }
}

class SepiaFilterOperation: AsyncOperation, FilteredImageProvider {
    var outputImage: UIImage? {
        if imageState == .new {
            return nil
        } else {
            return image
        }
    }
    
    enum ImageState {
        case new
        case filtered
    }
    
    var image: UIImage
    var imageState: ImageState = .new
    var groups = [Group]()
    
    init(_ image: UIImage) {
        self.image = image
    }
    
    override func main() {
        
        if isCancelled { return }
        
        if let filteredImage = applySepiaFilter(self.image) {
            self.image = filteredImage
            self.imageState = .filtered
            self.state = .finished
        }
        
//        let service = NetworkService()
//        service.getGroups { [weak self] groups in
//            self?.groups = groups
//            self?.state = .finished
//        }
    }
    
    private func applySepiaFilter(_ image: UIImage) -> UIImage? {
        guard let data = image.pngData() else { return nil }
        
        if isCancelled { return nil }
        
        let inputImage = CIImage(data: data)
        let context = CIContext(options: nil)
        
        guard let filter = CIFilter(name: "CISepiaTone") else { return nil }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(0.8, forKey: "inputIntensity")
        
        if isCancelled { return nil }
        
        guard let outputImage = filter.outputImage,
            let outImage = context.createCGImage(outputImage, from: outputImage.extent)  else { return nil }
        
        return UIImage(cgImage: outImage)
    }
}
class VignetteFilterOperation: Operation {
    enum ImageState {
        case new
        case filtered
    }
    
    var image: UIImage?
    var imageState: ImageState = .new
    
    override func main() {
        guard let dependency = dependencies.filter({ $0 is FilteredImageProvider}).first as? FilteredImageProvider,
            let image = dependency.outputImage else { return }
        
        if let filteredImage = applyVignetteFilter(to: image) {
            self.image = filteredImage
            self.imageState = .filtered
        }
    }
    
    private func applyVignetteFilter(to image: UIImage) -> UIImage? {
        guard let data = image.pngData() else { return nil }
        
        if isCancelled { return nil }
        
        let inputImage = CIImage(data: data)
        let context = CIContext(options: nil)
        
        guard let filter = CIFilter(name: "CIVignette") else { return nil }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(-5, forKey: "inputIntensity")
        filter.setValue(5, forKey: "inputRadius")
        
        if isCancelled { return nil }
        
        guard let outputImage = filter.outputImage,
            let outImage = context.createCGImage(outputImage, from: outputImage.extent)  else { return nil }
        
        return UIImage(cgImage: outImage)
    }
}
