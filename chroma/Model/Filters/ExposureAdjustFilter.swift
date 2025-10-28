//
//  ExposureAdjustFilter.swift
//  chroma
//
//  Created by Ekaterina Kolesnikova on 27.10.2025.
//

import CoreImage

class ExposureAdjustFilter: FilterProtocol, CIExposureAdjust {
    func apply(options: [String : Float]) {
        self.ev = options["ev"] ?? 2
        self.outputImage = self.applyFilter()
    }
    
    let options: [String : (Float, Float)] = [
        "ev": (0,10)
    ]
    var currentOption: [String : Float] {
        get { [
            "ev": self.ev
            ]
        }
    }
    
    
    var ev: Float = 2{
        didSet {
            self.outputImage = self.applyFilter()
        }
    }
    
    
    var name: String = "Exposure Adjust"
    
    func applyFilter() -> CIImage? {
        return exposureAdjust()
    }
    func exposureAdjust() -> CIImage {
        let exposureAdjustFilter = CIFilter.exposureAdjust()
        exposureAdjustFilter.inputImage = self.inputImage
        exposureAdjustFilter.ev = ev
        return exposureAdjustFilter.outputImage!
    }
    
    var inputImage: CIImage?
    var outputImage: CIImage?
    
    required init(inputImage: CIImage?) {
        self.inputImage = inputImage
        
        self.outputImage = applyFilter()
    }
    
    
}
