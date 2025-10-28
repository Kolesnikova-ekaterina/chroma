//
//  chromaApp.swift
//  chroma
//
//  Created by Ekaterina Kolesnikova on 26.10.2025.
//

import SwiftUI
import UIKit

@main
struct chromaApp: App {
    var body: some Scene {
        WindowGroup {
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
    }
}
