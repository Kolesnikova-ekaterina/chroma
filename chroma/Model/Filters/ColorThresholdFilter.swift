//
//  ColorThresholdFilter.swift
//  chroma
//
//  Created by Ekaterina Kolesnikova on 27.10.2025.
//

import CoreImage

class ColorThresholdFilter: FilterProtocol, CIColorThreshold {
    func apply(options: [String : Float]) {
        self.threshold = options["threshold"] ?? 0.0
        self.outputImage = self.applyFilter()
    }
    
    let options: [String : (Float, Float)] = [
        "threshold" : (0, 1)
    ]
    var currentOption: [String : Float] {
        get { [
            "threshold": self.threshold
            ]
        }
    }
    
    var inputImage: CIImage?
    
    var threshold: Float = 0.5 {
        didSet {
            self.outputImage = self.applyFilter()
        }
    }
    
    var outputImage: CIImage?
    
    let name: String = "Color Threshold"
    
    required init(inputImage: CIImage?) {
        self.inputImage = inputImage
        self.outputImage = applyFilter()
    }
    
    func applyFilter() -> CIImage? {
        return colorThreshold(inputImage: self.inputImage)
    }
    
    private func colorThreshold(inputImage: CIImage?) -> CIImage? {
        let filter = CIFilter.colorThreshold()
        filter.inputImage = inputImage
        filter.threshold = 0.5
        return filter.outputImage
    }
}
