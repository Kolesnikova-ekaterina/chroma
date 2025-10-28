//
//  GammaFilter.swift
//  chroma
//
//  Created by Ekaterina Kolesnikova on 27.10.2025.
//

import CoreImage

class GammaAdjustFilter: FilterProtocol, CIGammaAdjust {
    func apply(options: [String : Float]) {
        self.power = options["power"] ?? 4
        self.outputImage = self.applyFilter()
    }
    
    let options: [String : (Float, Float)] = [
        "power": (0,10)
    ]
    var currentOption: [String : Float] {
        get { [
            "power": self.power
            ]
        }
    }
    
    var power: Float = 4{
        didSet {
            self.outputImage = self.applyFilter()
        }
    }
    
    
    var name: String = "Gamma Adjust"
    
    func applyFilter() -> CIImage? {
        return gammaAdjust()
    }
    private func gammaAdjust() -> CIImage {
        let gammaAdjustFilter = CIFilter.gammaAdjust()
        gammaAdjustFilter.inputImage = self.inputImage
        gammaAdjustFilter.power = power
        return gammaAdjustFilter.outputImage!
    }
    
    var inputImage: CIImage?
    var outputImage: CIImage?
    
    required init(inputImage: CIImage?) {
        self.inputImage = inputImage
        self.outputImage = applyFilter()
    }
    
    
}
