//
//  FilterProtocol.swift
//  chroma
//
//  Created by Ekaterina Kolesnikova on 27.10.2025.
//

import CoreImage

protocol FilterProtocol {
    var inputImage: CIImage? { get set }
    var outputImage: CIImage? { get set }
    var name: String { get }
    func applyFilter() -> CIImage?
    init(inputImage: CIImage?)
    var options: [String: (Float, Float)] { get }
    var currentOption: [String: Float] { get }
    func apply(options: [String: Float]) -> ()
    
}
