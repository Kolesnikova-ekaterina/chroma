//
//  NormalFilter.swift
//  chroma
//
//  Created by Ekaterina Kolesnikova on 27.10.2025.
//

import CoreImage

class NormalFilter: FilterProtocol, CIFilterProtocol {
    func apply(options: [String : Float]) {
    }
    
    let options: [String : (Float, Float)] = [:]
    var currentOption: [String : Float] {
        get { [:] }
    }
    
    var name: String = "Normal"
    
    func applyFilter() -> CIImage? {
        return inputImage
    }
    
    var inputImage: CIImage?
    var outputImage: CIImage?
    
    required init(inputImage: CIImage?) {
        self.inputImage = inputImage
        self.outputImage = applyFilter()
    }
    
}
