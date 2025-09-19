//
//  ContentView.swift
//  NetworkMetric
//
//  Created by Vagner Oliveira on 19/09/25.
//

import SwiftUI
import SwiftData
import Streamline

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Post.Data]
    
    @ObservedObject var viewModel = ViewModel()
    @State var metric: NetworkMetric?
    
    private func postDetails(_ postData: Post.Data) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("ID: \(postData.userId)")
                .font(.title)
                .fontWeight(.heavy)
            Text("Titulo: \(postData.title)")
                .font(.headline)
                .fontWeight(.medium)
            Text("Descrição: \(postData.body)")
                .font(.subheadline)
                .fontWeight(.light)
        }
        .padding()
        .background(.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    var body: some View {
        ZStack {
            NavigationSplitView {
                
                if let metric {
                    MetricsView(metric: metric)
                }
                
                List {
                    ForEach(items, id: \.id) { postData in
                        NavigationLink {
                            postDetails(postData)
                        } label: {
                            Text(postData.title)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button {
                            addItem(post: .init(userId: Int.random(in: 1...100), title: "Algo", body: "Descricao"))
                        } label: {
                            Label("Add Item", systemImage: "plus")
                        }
                        
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Button {
                            viewModel.getAllPosts { result in
                                switch result {
                                case .success(let posts):
                                    
                                    posts.forEach {
                                        let postData = Post.Data(post: $0)
                                        // modelContext.insert(postData)
                                    }
                                case .failure(let failure):
                                    print("Error", failure)
                                }
                            }
                        } label: {
                            Text("Carregar")
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            } detail: {
                Text("Select an item")
            }
            .onAppear {
                APIURLSession.shared.onMetric = { metric in
                    self.metric = metric
                }
            }
            
            if viewModel.isLoading {
                ProgressView("Carregando...")
            }
        }
    }
    
    private func addItem(post: Post) {
        withAnimation {
            let newItem = Post.Data(post: post)
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Post.Data.self, inMemory: true)
}
