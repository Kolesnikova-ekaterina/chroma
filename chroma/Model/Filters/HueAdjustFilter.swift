//
//  HueAdjustFilter.swift
//  chroma
//
//  Created by Ekaterina Kolesnikova on 27.10.2025.
//

import CoreImage

class HueAdjustFilter: FilterProtocol, CIHueAdjust {
    func apply(options: [String : Float]) {
        self.angle = options["angle"] ?? 5
        self.outputImage = self.applyFilter()
    }
    
    let options: [String : (Float, Float)]=[
        "angle" : (-90, 90)
    ]
    var currentOption: [String : Float] {
        get { [
            "angle": self.angle
            ]
        }
    }
    
    var angle: Float = 5{
        didSet {
            self.outputImage = self.applyFilter()
        }
    }
    
    
    var name: String = "Hue Adjust"
    
    func applyFilter() -> CIImage? {
        return hueAdjust()
    }
    private func hueAdjust() -> CIImage {
        let hueAdjustFilter = CIFilter.hueAdjust()
        hueAdjustFilter.inputImage = self.inputImage
        hueAdjustFilter.angle = self.angle
        return hueAdjustFilter.outputImage!
    }
    
    var inputImage: CIImage?
    var outputImage: CIImage?
    
    required init(inputImage: CIImage?) {
        self.inputImage = inputImage
        self.outputImage = applyFilter()
    }
    
    
}
