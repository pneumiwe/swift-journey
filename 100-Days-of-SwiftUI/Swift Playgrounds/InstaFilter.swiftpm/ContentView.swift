import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingFilters = false
    
    @State private var filterIntensity = 0.5
    @State private var filterScale = 0.5
    @State private var filterRadius = 0.5
    @State private var filterAngle = 0.5
    
    // currentFilter.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
    
    var inputKeys: [String] {
        currentFilter.inputKeys
    }
    
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    PhotosPicker(selection: $selectedItem) {
                        if let processedImage {
                            processedImage
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(16)
                        } else {
                            ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                        }
                    }
                    .buttonStyle(.plain)
                    .onChange(of: selectedItem, loadImage)
                }
                
                Group {
                    if inputKeys.contains(kCIInputIntensityKey) {
                        Section("Intensity") { Slider(value: $filterIntensity) }
                    }
                    if inputKeys.contains(kCIInputRadiusKey) {
                        Section("Radius") { Slider(value: $filterRadius) }
                    }
                    if inputKeys.contains(kCIInputScaleKey) {
                        Section("Scale") { Slider(value: $filterScale) }
                    }
                    if inputKeys.contains(kCIInputAngleKey) {
                        Section("Angle") { Slider(value: $filterAngle) }
                    }
                }
                .onChange(of: [filterIntensity, filterRadius, filterScale, filterAngle], applyProcessing)
                .disabled(processedImage == nil)
                
                Button("Change Filter", action: changeFilter)
                    .disabled(processedImage == nil)
            }
            .navigationTitle("InstaFilter")
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                Button("Crystallize") { setFilter(CIFilter.crystallize() )}
                Button("Edges") { setFilter(CIFilter.edges() )}
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur() )}
                Button("Pixellate") { setFilter(CIFilter.pixellate() )}
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone() )}
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask() )}
                Button("Vignette") { setFilter(CIFilter.vignette() )}
                Button("Color Invert") { setFilter(CIFilter.colorInvert() )}
                Button("Kaleidoscope") { setFilter(CIFilter.kaleidoscope() )}
                Button("Comic") { setFilter(CIFilter.comicEffect() )}
            }
            .toolbar {
                if let processedImage {
                    ShareLink(item: processedImage, preview: SharePreview("InstaFilter image", image: processedImage))
                }
            }
        }
    }
    
    func changeFilter() {
        showingFilters = true
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    func applyProcessing() {
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            if currentFilter == CIFilter.vignette() {
                currentFilter.setValue(filterRadius * 2, forKey: kCIInputRadiusKey)
            } else {
                currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)
            }
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScale * 50, forKey: kCIInputScaleKey)
        }
        if inputKeys.contains(kCIInputAngleKey) {
            currentFilter.setValue(filterAngle, forKey: kCIInputAngleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    @MainActor func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        
        filterCount += 1
        
        if filterCount >= 3 {
            requestReview()
        }
    }
}
