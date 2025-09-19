//
//  Post.swift
//  NetworkMetric
//
//  Created by Vagner Oliveira on 19/09/25.
//

import Foundation
import Streamline
import SwiftData


final class Post: Model {
    let userId: Int
    let title: String
    let body: String
    
    init(userId: Int, title: String, body: String) {
        self.userId = userId
        self.title = title
        self.body = body
    }
    
    @Model
    final class Data {
        var userId: Int
        var title: String
        var body: String
        
        init(userId: Int, title: String, body: String) {
            self.userId = userId
            self.title = title
            self.body = body
        }
        
        convenience init(post: Post) {
            self.init(userId: post.userId, title: post.title, body: post.body)
        }
    }
}
