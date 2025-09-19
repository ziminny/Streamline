//
//  Array+Model.swift
//  NetworkMetric
//
//  Created by Vagner Oliveira on 19/09/25.
//

import Foundation
import Streamline

extension Array: @retroactive Model where Element: Model {}
