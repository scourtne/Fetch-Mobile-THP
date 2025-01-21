//
//  ContentView.swift
//  FetchTakeHomeProject
//
//  Created by Sam Courtney on 1/16/25.
//

import Foundation
import SwiftUI

@MainActor
class RecipeBookViewModel: ObservableObject {
    @Published var recipeBook: Result<RecipeBookModel, Error>?
    @Published var fetchedTimestamp = Date()
    
    let api = RecipeAPIManager()

    func reload() async {
        // Deliberately do not nil out the existing recipes so there is content when a refresh is occuring
        fetchedTimestamp = Date()
        // This is purely for testing purposes to show there is a loading spinner
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        do {
            let result = try await api.fetchRecipeBook()
            recipeBook = .success(RecipeBookModel(apiModel: result))
        } catch {
            recipeBook = .failure(error)
            debugPrint("Error: \(String(describing: error))")
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel = RecipeBookViewModel()
    var imageFetcher = ImageFetcher()
    
    var body: some View {
        List {
            switch viewModel.recipeBook {
            case .none:
                HStack {
                    Text("Fetching recipes...")
                    ProgressView()
                }
                
            case .success(let recipeBook):
                if recipeBook.recipeCollections.isEmpty {
                    // I left this view in here to demonstrate one way of passing more involved
                    // information to an empty state, but for now it just ends up being a message
                    // that nothing was found
                    EmptyView(viewModel: EmptyViewModel(timestamp: viewModel.fetchedTimestamp))
                } else {
                    // Sort by cuisine so there's a little less text in each cell
                    let collections: [RecipeCollection] = recipeBook.recipeCollections
                    ForEach(collections) { collection in
                        Section(header: Text(collection.cuisine)) {
                            ForEach(collection.recipes) { recipe in
                                recipeRow(for: recipe)
                            }
                        }
                    }
                }
                
            case .failure:
                Text("Unable to fetch recipes")
            }
        }
        .toolbar { // Table footer
            ToolbarItemGroup(placement: .bottomBar) {
                Text("Last fetched on \(dateFormatter.string(from: viewModel.fetchedTimestamp))")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .task {
            await viewModel.reload()
        }
        .refreshable {
            await viewModel.reload()
        }
//        .padding([.bottom, .top])
        .navigationTitle("Recipes")
    }
    
    func recipeRow(for recipe: RecipeModel) -> RecipeRowView {
        let model = RecipeRowViewModel(recipe: recipe,
                                       imageFetcher: imageFetcher)
        return RecipeRowView(viewModel: model)
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter
    }()
}

#Preview {
    ContentView()
}
