//
//  BokehBlurFilter.swift
//  chroma
//
//  Created by Ekaterina Kolesnikova on 27.10.2025.
//

import CoreImage

class BokehBlurFilter: FilterProtocol, CIBokehBlur {
    func apply(options: [String : Float]) {
        self.radius = options["radius"] ?? self.radius
        self.ringAmount = options["ringAmount"] ?? self.ringAmount
        self.ringSize = options["ringSize"] ?? self.ringSize
        self.softness = options["softness"] ?? self.softness
        
        
        self.outputImage = self.applyFilter()
    }
    
    
    var radius: Float = 20{
        didSet {
            self.outputImage = self.applyFilter()
        }
    }
    
    var ringAmount: Float = 0{
        didSet {
            self.outputImage = self.applyFilter()
        }
    }
    
    var ringSize: Float = 0.1{
        didSet {
            self.outputImage = self.applyFilter()
        }
    }
    
    var softness: Float = 1{
        didSet {
            self.outputImage = self.applyFilter()
        }
    }
    
    let options: [String : (Float, Float)] = [
        "radius": (0, 40),
        "ringAmount": (0,5),
        "ringSize": (0, 0.5),
        "softness": (0, 5)
    ]
    
    var currentOption: [String : Float] {
        get { [
            "radius": self.radius,
            "ringAmount": self.ringAmount,
            "ringSize": self.ringSize,
            "softness": self.softness
            ]
        }
    }
    
    var name: String = "Bokeh Blur"
    
    func applyFilter() -> CIImage? {
        return bokehBlur()
    }
    
    var inputImage: CIImage?
    var outputImage: CIImage?
    
    func bokehBlur() -> CIImage? {
        let bokehBlurFilter = CIFilter.bokehBlur()
        bokehBlurFilter.inputImage = self.inputImage
        bokehBlurFilter.ringSize = self.ringSize
        bokehBlurFilter.ringAmount = self.ringAmount
        bokehBlurFilter.softness = self.softness
        bokehBlurFilter.radius = self.radius
        return bokehBlurFilter.outputImage
    }
    
    required init(inputImage: CIImage?) {
        self.inputImage = inputImage
        self.outputImage = applyFilter()
    }
    
    
}
