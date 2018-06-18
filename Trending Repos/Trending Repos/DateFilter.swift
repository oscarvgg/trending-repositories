//
//  DateFilterable.swift
//  Trending Repos
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation
import TrendingReposData

public enum DateFilter: DateFilterable {
    case day
    case week
    case month
    
    public var date: Date {
        
        switch self {
        case .day:
            return Calendar.current.date(byAdding: .day,
                                         value: -1,
                                         to: Date()) ?? Date()
        case .week:
            return Calendar.current.date(byAdding: .day,
                                         value: -7,
                                         to: Date()) ?? Date()
        case .month:
            return Calendar.current.date(byAdding: .month,
                                         value: -1,
                                         to: Date()) ?? Date()
        }
    }
}
