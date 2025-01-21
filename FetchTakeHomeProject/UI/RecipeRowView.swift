//
//  RecipeInfoCell.swift
//  FetchTakeHomeProject
//
//  Created by Sam Courtney on 1/18/25.
//

import Foundation
import SwiftUI

// Ideally this would live in a separate file, but now now it's easier to look at this in one spot
class RecipeRowViewModel: ObservableObject {
    @Published private(set) var recipe: RecipeModel
    @Published var image: UIImage?
    private var imageFetcher: ImageFetcher
    
    init(recipe: RecipeModel, imageFetcher: ImageFetcher) {
        self.recipe = recipe
        self.imageFetcher = imageFetcher
        Task {
            await fetchImage()
        }
    }
    
    var formattedName: String {
        "\(recipe.name)"
    }
    
    var formattedCuisine: String {
        return "\(recipe.cuisine) Cuisine"
    }
    
    var source: (String, URL)? {
        guard let text = recipe.sourceUrl, let url = URL(string: text) else {
            return nil
        }
        
        return ("Source", url)
    }
    
    var youtube: (String, URL)? {
        guard let text = recipe.youtubeUrl, let url = URL(string: text) else {
            return nil
        }
        
        return ("Video", url)
    }
    
    @MainActor
    private func fetchImage() async {
        guard let imageUrl = recipe.photoUrlSmall else {
            return
        }

        do {
            image = try await imageFetcher.image(at: imageUrl)
        } catch {
            debugPrint("Error: \(String(describing: error))")
        }
    }
}

/// Informational cell for easy display of name, photo, and cuisine type
struct RecipeRowView: View {
    @ObservedObject var viewModel: RecipeRowViewModel
    
    enum UIConstants {
        static let imageSize = CGSize(width: 60, height: 60)
        static let placeholderSize = CGSize(width: 60, height: 60)
    }
    
    var body: some View {
        HStack(spacing: 10) {
            // Would ideally use AsyncImage
            // TODO: Image first - need to figure out caching
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIConstants.imageSize.width,
                           height: UIConstants.imageSize.height)
                    .clipShape(.rect(cornerRadius: 5))
            } else {
                Image(systemName: "fork.knife.circle.fill")
                    .resizable()
                    .frame(width: UIConstants.imageSize.width,
                           height: UIConstants.imageSize.height)
                    .foregroundStyle(.tint)
            }
            VStack(alignment: .leading) {
                Text(viewModel.formattedName)
                Text(viewModel.formattedCuisine)
                    .font(.footnote)
                HStack(spacing: 20) {
                    // Do this because list causes only one to work when they're in the same cell
                    if let (sourceText, sourceUrl) = viewModel.source {
                        HStack {
                            Image(systemName: "list.bullet")
                                .foregroundStyle(linkStyling)
                            Text(sourceText)
                                .foregroundStyle(linkStyling)
                        }
                        .onTapGesture {
                            UIApplication.shared.open(sourceUrl)
                        }

                    }
                    if let (text, url) = viewModel.youtube {
                        HStack {
                            Image(systemName: "play.rectangle")
                                .foregroundStyle(linkStyling)
                            Text(text)
                                .foregroundStyle(linkStyling)
                        }
                        .onTapGesture {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
            Spacer()
        }
    }
    
    var linkStyling: some ShapeStyle {
        if #available(iOS 17.0, *) {
            return .link
        } else {
            return .blue
        }
    }
}

#Preview {
    let imageFetcher = ImageFetcher()
    let recipes = [
        RecipeAPIModel(cuisine: "Malaysian",
               name: "Apam Balik (images)",
               photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
               photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
               uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
               sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
               youtubeUrl: "https://www.youtube.com/watch?v=4vhcOwVBDO4"),
        RecipeAPIModel(cuisine: "Malaysian",
               name: "Apam Balik (no images)",
               photoUrlLarge: nil,
               photoUrlSmall: nil,
               uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
               sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
               youtubeUrl: "https://www.youtube.com/watch?v=4vhcOwVBDO4"),
        RecipeAPIModel(cuisine: "Malaysian",
               name: "Apam Balik (no source)",
               photoUrlLarge: nil,
               photoUrlSmall: nil,
               uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
               sourceUrl: nil,
               youtubeUrl: "https://www.youtube.com/watch?v=4vhcOwVBDO4"),
        RecipeAPIModel(cuisine: "Malaysian",
               name: "Apam Balik (no youtube)",
               photoUrlLarge: nil,
               photoUrlSmall: nil,
               uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
               sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
               youtubeUrl: nil),
        RecipeAPIModel(cuisine: "Malaysian",
               name: "Apam Balik (no links)",
               photoUrlLarge: nil,
               photoUrlSmall: nil,
               uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
               sourceUrl: nil,
               youtubeUrl: nil)
    ]
    List(recipes, id: \.name) { recipe in
        RecipeRowView(viewModel: RecipeRowViewModel(recipe: RecipeModel(apiModel: recipe),
                                                    imageFetcher: imageFetcher))
    }
}
