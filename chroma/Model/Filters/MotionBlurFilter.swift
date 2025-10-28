//
//  MotionBlurFilter.swift
//  chroma
//
//  Created by Ekaterina Kolesnikova on 27.10.2025.
//

import CoreImage

class MotionBlurFilter: FilterProtocol, CIMotionBlur {
    func apply(options: [String : Float]) {
        self.angle = options["angle"] ?? self.angle
        self.radius = options["radius"] ?? self.radius
        
        self.outputImage = self.applyFilter()
    }
    
    let options: [String : (Float, Float)] = [
        "radius": (0, 100),
        "angle" : (-90, 90)
    ]
    var currentOption: [String : Float] {
        get { [
            "radius": self.radius,
            "angle": self.angle
            ]
        }
    }
    
    var radius: Float = 20{
        didSet {
            self.outputImage = self.applyFilter()
        }
    }
    
    var angle: Float = 0{
        didSet {
            self.outputImage = self.applyFilter()
        }
    }
    
    
    var name: String = "Motion Blur"
    
    func applyFilter() -> CIImage? {
        return motionBlur()
    }
    func motionBlur() -> CIImage? {
        let motionBlurFilter = CIFilter.motionBlur()
        motionBlurFilter.inputImage = self.inputImage
        motionBlurFilter.angle = self.angle
        motionBlurFilter.radius = self.radius
        return motionBlurFilter.outputImage
    }
    
    var inputImage: CIImage?
    var outputImage: CIImage?
    
    required init(inputImage: CIImage?) {
        self.inputImage = inputImage
        self.outputImage = applyFilter()
    }
    
    
}
