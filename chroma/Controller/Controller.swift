//
//  Controller.swift
//  chroma
//
//  Created by Ekaterina Kolesnikova on 26.10.2025.
//

import Foundation
internal import Combine
import UIKit
import SwiftUI
import PhotosUI

class ChromaController: ObservableObject {
    @Published var chroma: ChromaModel// The Model
    
    @Published var saveStatus: String?
    
    var miniatures: [String : (String?,Image)] = [:]
    @Published var isFiltered: Bool = false
    var options: [String:(Float, Float)] {
        get {
            chroma.getOptions()
        }
    }
    @Published var currentOptions: [String:Float] = [:]
    
    var image: Image{
        get {
            let ciimage = chroma.filteredImage!
            return convertCIImageToImage(ciImage: ciimage)
        }
        set{
            
        }
    }
    
    @Published var isShowingPhotoPicker = false
    @Published var selectedItem: PhotosPickerItem? {
            didSet {
                loadImage()
            }
        }
    
    init(chroma: ChromaModel) {
        self.chroma = chroma
        self.miniatures = chroma.miniatures.mapValues{ (name, ciImage) in
            (name, convertCIImageToImage(ciImage: ciImage ?? CIImage()))
        }
        
        self.currentOptions = self.chroma.getCurrentOptions()
    }
    private func convertCIImageToImage (ciImage: CIImage?) -> Image {
        if (ciImage==nil){
            return Image("")
        }
        let cgimage = convertCIImageToCGImage(ciImage: ciImage!)
        if (cgimage==nil){
            return Image("")
        }
        let uiImage = UIImage(cgImage: cgimage!)
        return Image(uiImage: uiImage)
    }
    
    private func convertCIImageToCGImage(ciImage: CIImage) -> CGImage? {
        let context = CIContext()
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            return cgImage
        }
        return nil
    }
    
    func filterChange(filter: String){
        self.isFiltered = true
        self.chroma.changeFilter(name: filter)
        self.currentOptions = self.chroma.getCurrentOptions()
    }
    
    func applyChanges(options: [String:Float]){
        self.chroma.applyChanges(options: options)
        self.miniatures = chroma.miniatures.mapValues{ (name, ciImage) in
            (name, convertCIImageToImage(ciImage: ciImage ?? CIImage()))
        }
        //isFiltered = true
    }
    
    func onPressCancel(){
        isFiltered = false
        chroma.cancel()
    }
    
    func onPressConfirm(){
        isFiltered = false
        chroma.confirm()
    }
    
    func openPhotoPicker() {
            isShowingPhotoPicker = true
        }
    
    private func loadImage() {
            guard let selectedItem = selectedItem else { return }
            
            Task {
                if let data = try? await selectedItem.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        await MainActor.run {
                            self.image = Image(uiImage: uiImage)
                            chroma.reloadPhoto(
                                CIImage(
                                    image: uiImage) ?? CIImage() )
                        }
                    }
                }
            }
        }
    
    func saveImage() {
        let context = CIContext()
        if let cgImage = context.createCGImage(chroma.filteredImage!, from: chroma.filteredImage!.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            
            let imageSaver = ImageSaver()
            
            imageSaver.successHandler = {
                // Все UI-обновления должны происходить в главном потоке
                DispatchQueue.main.async {
                    self.saveStatus = "Фотография успешно сохранена!"
                }
            }
            
            imageSaver.errorHandler = { error in
                DispatchQueue.main.async {
                    self.saveStatus = "Ошибка сохранения: \(error.localizedDescription)"
                }
            }
            
            imageSaver.writeToPhotoAlbum(image: uiImage)
        } else {
            self.saveStatus = "Не удалось преобразовать изображение."
        }
    }
    
    
}

