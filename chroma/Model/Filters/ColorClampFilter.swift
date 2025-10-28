//
//  ColorClampFilter.swift
//  chroma
//
//  Created by Ekaterina Kolesnikova on 27.10.2025.
//

import CoreImage
import CoreImage.CIFilterBuiltins

class ColorClampFilter: FilterProtocol, CIColorClamp {
    func apply(options: [String : Float]) {
        var newVector = CIVector(x: CGFloat(options["minComponents_x"] ?? 0),
                                 y: CGFloat(options["minComponents_y"] ?? 0),
                                 z: CGFloat(options["minComponents_z"] ?? 0),
                                 w: 0)
        self.minComponents = newVector
        
        newVector = CIVector(x: CGFloat(options["maxComponents_x"] ?? 1),
                             y: CGFloat(options["maxComponents_y"] ?? 1),
                             z: CGFloat(options["maxComponents_z"] ?? 1),
                             w: 1)
        self.maxComponents = newVector
        
        self.outputImage = self.applyFilter()
    }
    
    var inputImage: CIImage?
    
    var minComponents: CIVector = CIVector(x: 1, y: 0, z: 0, w: 0){
        didSet {
            self.outputImage = self.applyFilter()
        }
    }

    
    var maxComponents: CIVector = CIVector (x: 1, y: 1, z: 1, w: 1){
        didSet {
            self.outputImage = self.applyFilter()
        }
    }
    let options: [String : (Float, Float)] = [
        "minComponents_x": (0, 1),
        "minComponents_y": (0, 1),
        "minComponents_z": (0, 1),
        "maxComponents_x": (0, 1),
        "maxComponents_y": (0, 1),
        "maxComponents_z": (0, 1),
    ]
    var currentOption: [String : Float] {
        get { [
            "minComponents_x": Float(minComponents.x),
            "minComponents_y": Float(minComponents.y),
            "minComponents_z": Float(minComponents.z),
            "maxComponents_x":Float( maxComponents.x),
            "maxComponents_y": Float(maxComponents.y),
            "maxComponents_z": Float(maxComponents.z),
            ]
        }
    }
    
    var outputImage: CIImage?
    
    required init(inputImage: CIImage?) {
        self.inputImage = inputImage
        self.outputImage = applyFilter()
    }
    
    func applyFilter() -> CIImage? {
        return colorClamp(inputImage: self.inputImage)
    }
    
    let name: String = "Color Clamp" 
    
    private func colorClamp(inputImage: CIImage?) -> CIImage? {
        let colorClampFilter = CIFilter.colorClamp()
        colorClampFilter.inputImage = inputImage
        colorClampFilter.minComponents = self.minComponents
        colorClampFilter.maxComponents = self.maxComponents
        return colorClampFilter.outputImage
    }
}
