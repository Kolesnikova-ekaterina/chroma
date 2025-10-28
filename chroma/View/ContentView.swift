//
//  ContentView.swift
//  chroma
//
//  Created by Ekaterina Kolesnikova on 26.10.2025.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @ObservedObject var chromaController: ChromaController // Observing the Controller
    
    var body: some View {
        VStack {
            TopBar()
                .containerRelativeFrame(.vertical, count: 8, span: 1, spacing: 5)
            
            Main(
                image: chromaController.image,
                openPhotoPicker: chromaController.openPhotoPicker,
                SavePhoto: chromaController.saveImage,
                chromaController: chromaController
            )
                .containerRelativeFrame(.vertical, count: 8, span: 5, spacing: 5)
            if (chromaController.isFiltered)
            {
                Options(
                    options: chromaController.options,
                    onPressCancel:
                        chromaController.onPressCancel
                    ,
                    onPressConfirm:
                        chromaController.onPressConfirm
                    ,
                    currentOptions: $chromaController.currentOptions,
                    onUpdate: {newOptions in
                        chromaController.applyChanges(options: newOptions)
                    }
                )
                    .containerRelativeFrame(.vertical, count: 8, span: 2, spacing: 5)
            }else {
                Filters(
                    miniatures: chromaController.miniatures,
                    onMiniaturePress: chromaController.filterChange
                )
                .containerRelativeFrame(.vertical, count: 8, span: 2, spacing: 5)
            }
            
        }
        .padding()
    }
}

#Preview {
    var controller = ChromaController(
        chroma: ChromaModel(
            image: CIImage(
                image: UIImage(
                    named: "default")!
            )
        )
    )
    ContentView(chromaController: controller)
}

struct TopBar: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "theatermask.and.paintbrush")
                                .imageScale(.large)
                                .foregroundStyle(.tint)
                            Text("Chroma")
            }.fontWeight(.bold)
        }
    }
}

struct Main: View {
    var image: Image
    var openPhotoPicker: () -> ()
    var SavePhoto: () -> ()
    var chromaController : ChromaController
    var body: some View {
        NavigationStack {
            image
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button( "Open") {
                            openPhotoPicker()
                        }
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        Button("Save") {
                            SavePhoto()
                        }
                    }
                }.photosPicker(
                    isPresented: Binding(
                                    get: { chromaController.isShowingPhotoPicker },
                                    set: { chromaController.isShowingPhotoPicker = $0 }
                                ),
                                selection: Binding(
                                    get: { chromaController.selectedItem },
                                    set: { chromaController.selectedItem = $0 }
                                ),
                                matching: .images
                )
        }
    }
}

struct Filters: View {
    var miniatures: [String: (String?, Image)]
    let onMiniaturePress: (String)->()
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack
            {
                ForEach(miniatures.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    VStack {
                        Text("\(value.0 ?? "")")
                        value.1.resizable()
                                .scaledToFit()
                    }.onTapGesture {
                        onMiniaturePress(key)
                    }
                }
            }
        }
    }
}

import SwiftUI

struct Options: View {
    var options: [String:(Float, Float)]
    var onPressCancel: () -> ()
    var onPressConfirm: () -> ()
    @Binding var currentOptions: [String:Float]
    var onUpdate: ([String: Float]) -> ()
    @State private var localOptions: [String: Float] = [:]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                HStack {
                    Button(action: {
                        onPressCancel()
                    }) {
                        Text("Cancel")
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        onPressConfirm()
                    }) {
                        Text("Confirm")
                    }
                    .padding()
                }
                
                ForEach(options.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack {
                        Text(key)
                        Slider(
                            value: Binding(
                                get: { self.localOptions[key] ?? value.0 },
                                set: { newValue in self.localOptions[key] = newValue }
                            ),
                            in: value.0...value.1,
                            onEditingChanged: { isEditing in
                                if !isEditing {
                                    self.currentOptions[key] = self.localOptions[key]
                                    onUpdate(self.currentOptions)
                                }
                            }
                        )
                        .padding(.horizontal)
                    }
                    .padding()
                }
            }
        }
    }
}
