//
//  EmptyView.swift
//  FetchTakeHomeProject
//
//  Created by Sam Courtney on 1/18/25.
//

import Foundation
import SwiftUI

class EmptyViewModel: ObservableObject {
    @Published private(set) var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter
    }()
    
    var formattedTimestamp: String {
        "As of \(EmptyViewModel.dateFormatter.string(from: timestamp))"
    }
}

struct EmptyView: View {
    @ObservedObject var viewModel: EmptyViewModel
    
    var body: some View {
        VStack {
            Text("No recipes found")
//            Text(viewModel.formattedTimestamp)
//                .font(.footnote)
        }
    }
}

#Preview {
    EmptyView(viewModel: EmptyViewModel(timestamp: Date()))
}
