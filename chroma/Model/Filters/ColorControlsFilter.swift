//
//  ColorControlsFilter.swift
//  chroma
//
//  Created by Ekaterina Kolesnikova on 27.10.2025.
//

import CoreImage

class ColorControlsFilter: FilterProtocol, CIColorControls {
    func apply(options: [String : Float]) {
        self.brightness = options["brightness"] ?? 0
        self.contrast = options["contrast"] ?? 1
        self.saturation = options["saturation"] ?? 0
        
        self.outputImage = self.applyFilter()
    }
    
    
    let options: [String : (Float, Float)] = [
        "saturation": (-1,1),
        "brightness": (-1, 1),
        "contrast": (-1, 1)
    ]
    
    var currentOption: [String : Float] {
        get { [
            "saturation": self.saturation,
            "brightness": self.brightness,
            "contrast": self.contrast
            ]
        }
    }
    
    
    
    var inputImage: CIImage?
    
    var saturation: Float = 0 {
        didSet {
            self.outputImage = self.applyFilter()
        }
    }
    
    var brightness: Float = 0{
        didSet {
            self.outputImage = self.applyFilter()
        }
    }
    
    var contrast: Float = 1{
        didSet {
            self.outputImage = self.applyFilter()
        }
    }
    
    var outputImage: CIImage?
    
    let name: String = "Color Controls"
    
    required init(inputImage: CIImage? ) {
        self.inputImage = inputImage
        self.outputImage = applyFilter()
    }
    
    func applyFilter() -> CIImage? {
        return colorControls(inputImage: self.inputImage!)
    }
    
     private func colorControls(inputImage: CIImage?) -> CIImage? {
         let colorControlsFilter = CIFilter.colorControls()
         colorControlsFilter.inputImage = inputImage
         colorControlsFilter.brightness = brightness
         colorControlsFilter.contrast = contrast
         colorControlsFilter.saturation = saturation
         return colorControlsFilter.outputImage
     }
    
}
