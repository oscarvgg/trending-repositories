//
//  Delayable.swift
//  Trending Repos
//
//  Created by Oscar Gonzalez on 19/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation

protocol Delayable: class {
    var blockOperation: BlockOperation? { get set }
    func performDeleyedAction(dependencies: [String : Any])
}

extension Delayable {
    
    func performActionAfter(milliseconds: Int, dependencies: [String : Any]) {
        
        blockOperation?.cancel()
        
        blockOperation = BlockOperation(block: {
            self.performDeleyedAction(dependencies: dependencies)
        })
        
        DispatchQueue.main.asyncAfter(
        deadline: .now() + .milliseconds(milliseconds)) { [blockOperation] in
            guard let blockOperation = blockOperation, !blockOperation.isCancelled else {
                return
            }
            OperationQueue.main.addOperation(blockOperation)
        }
    }
}
