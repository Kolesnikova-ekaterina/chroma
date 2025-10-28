//
//  GlassDistortionFilter.swift
//  chroma
//
//  Created by Ekaterina Kolesnikova on 27.10.2025.
//

import CoreImage
import UIKit

class GlassDistortionFilter: FilterProtocol, CIGlassDistortion {
    func apply(options: [String : Float]) {
        self.scale = options["scale"] ?? 500
        self.outputImage = self.applyFilter()
    }
    
    let options: [String : (Float, Float)] = [
        "scale" : (0, 1000)
    ]
    var currentOption: [String : Float] {
        get { [
            "scale": self.scale
            ]
        }
    }
    
    var textureImage: CIImage?
    
    var center: CGPoint = CGPoint(x: 1791, y: 1344){
        didSet {
            self.outputImage = self.applyFilter()
        }
    }
    
    var scale: Float = 500{
        didSet {
            self.outputImage = self.applyFilter()
        }
    }
    
    
    var name: String = "Glass Distortion"
    
    func applyFilter() -> CIImage? {
        return glassDistortion()
    }
    func glassDistortion() -> CIImage {
        let filter = CIFilter.glassDistortion()
        filter.inputImage = self.inputImage
        filter.textureImage = self.textureImage
        filter.center = self.center
        filter.scale = self.scale
        return filter.outputImage!
    }
    
    var inputImage: CIImage?
    var outputImage: CIImage?
    
    required init(inputImage: CIImage?) {
        self.inputImage = inputImage
        let inputUIImage = UIImage(named: "Texture")
        guard let inputUIImage = inputUIImage else {
            // Handle the case where the image is not found.
            fatalError("Failed to load image from asset catalog.")
        }
        guard let ciImage = CIImage(image: inputUIImage) else {
            fatalError("Failed to create CIImage from UIImage.")
        }
        self.textureImage = ciImage
        
        self.outputImage = applyFilter()
    }
    
    
}
