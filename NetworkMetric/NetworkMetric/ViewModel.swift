//
//  ViewModel.swift
//  NetworkMetric
//
//  Created by Vagner Oliveira on 19/09/25.
//

import Foundation
import Streamline
import Combine

@MainActor
class ViewModel: ObservableObject {

    @Factory
    private var postService: PostService
    
    @Published var isLoading: Bool = false
    
    func getAllPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        isLoading = true
        Task {
            do {
                let posts = try await postService.getAll()
                completion(.success(posts))
                isLoading = false
            } catch {
                completion(.failure(error))
                isLoading = false
            }
        }
    }
    
}
