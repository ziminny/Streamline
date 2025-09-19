//
//  PostsService.swift
//  NetworkMetric
//
//  Created by Vagner Oliveira on 19/09/25.
//

import Foundation
import Streamline

final class PostService: ServiceProtocol {
    
    nonisolated(unsafe) private(set) var factory: HTTPServiceFactoryProtocol
    
    required init(withFactory factory: HTTPServiceFactoryProtocol) {
        self.factory = factory
    }
    
    func getAll() async throws -> [Post] {
        return try await factory
            .makeHttpService()
            .fetchAsync(
                [Post].self,
                parameters: Parameters(
                    method: .GET,
                    path: ApiPath.defaultPath(.posts)
                )
            ) ?? []
    }
}
