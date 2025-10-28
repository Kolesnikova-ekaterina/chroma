//
//  Model.swift
//  chroma
//
//  Created by Ekaterina Kolesnikova on 26.10.2025.
//

import UIKit

struct ChromaModel{
    var currentfilter = "normal"
    var image: CIImage?
    var filteredImage: CIImage?
    var filters : [String: (any FilterProtocol)?]
    var miniatures: [String: (String?, CIImage?)]
    
    
    
    init (image: CIImage?) {
        self.image = image
        self.filteredImage = image
        self.filters =
        ["normal": NormalFilter(inputImage: image),
         "colorClamp": ColorClampFilter(inputImage: image),
         "colorControls": ColorControlsFilter(inputImage: image),
         "colorThreshold": ColorThresholdFilter(inputImage: image),
         "exposureAdjust":ExposureAdjustFilter(inputImage: image),
         "gammaAdjust":GammaAdjustFilter(inputImage: image),
         "hueAdjust":HueAdjustFilter(inputImage: image),
         "glassDistortion": GlassDistortionFilter(inputImage: image),
         "bokehBlur":BokehBlurFilter(inputImage: image),
         "motionBlur":MotionBlurFilter(inputImage: image)
        ]
        self.miniatures = self.filters.mapValues{ filter in  (filter?.name,filter?.outputImage)}
        
    }
    
    mutating func changeFilter(name: String){
        self.currentfilter = name
        self.filteredImage = self.filters[self.currentfilter]??.outputImage
    }
    
    func getOptions() -> [String:(Float, Float)]{
        return self.filters[self.currentfilter]??.options ?? [:]
    }
    
    func getCurrentOptions() -> [String:Float]{
        return self.filters[self.currentfilter]??.currentOption ?? [:]
    }
    
    mutating func applyChanges(options: [String:Float]){
        self.filters[self.currentfilter]??.apply(options: options)
        self.filteredImage = self.filters[self.currentfilter]??.outputImage
    }
    
    mutating func cancel(){
        self.filteredImage = self.miniatures[self.currentfilter]?.1
    }
    
    mutating func confirm(){
        let image = self.filteredImage
        self.filters =
        ["normal": NormalFilter(inputImage: image),
         "colorClamp": ColorClampFilter(inputImage: image),
         "colorControls": ColorControlsFilter(inputImage: image),
         "colorThreshold": ColorThresholdFilter(inputImage: image),
         "exposureAdjust":ExposureAdjustFilter(inputImage: image),
         "gammaAdjust":GammaAdjustFilter(inputImage: image),
         "hueAdjust":HueAdjustFilter(inputImage: image),
         "glassDistortion": GlassDistortionFilter(inputImage: image),
         "bokehBlur":BokehBlurFilter(inputImage: image),
         "motionBlur":MotionBlurFilter(inputImage: image)
        ]
        self.miniatures = self.filters.mapValues{ filter in  (filter?.name,filter?.outputImage)}
    }
    
    mutating func reloadPhoto(_ image: CIImage){
        self.image = image
        self.currentfilter = "normal"
        self.filteredImage = image
        self.filters =
        ["normal": NormalFilter(inputImage: image),
         "colorClamp": ColorClampFilter(inputImage: image),
         "colorControls": ColorControlsFilter(inputImage: image),
         "colorThreshold": ColorThresholdFilter(inputImage: image),
         "exposureAdjust":ExposureAdjustFilter(inputImage: image),
         "gammaAdjust":GammaAdjustFilter(inputImage: image),
         "hueAdjust":HueAdjustFilter(inputImage: image),
         "glassDistortion": GlassDistortionFilter(inputImage: image),
         "bokehBlur":BokehBlurFilter(inputImage: image),
         "motionBlur":MotionBlurFilter(inputImage: image)
        ]
        self.miniatures = self.filters.mapValues{ filter in  (filter?.name,filter?.outputImage)}
    }
}
