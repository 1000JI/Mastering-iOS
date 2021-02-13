//
//  Copyright (c) 2018 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

class OperationQueueViewController: UIViewController {
    
    // Operation Queue 생성(main)
    let mainQueue = OperationQueue.main
    let backgroundQueue = OperationQueue()
    
    var isCancelled = false
    
    @IBAction func startOperation(_ sender: Any) {
        isCancelled = false
        
        backgroundQueue.addOperation {
            autoreleasepool {
                for _ in 1..<100 {
                    guard !self.isCancelled else { return }
                    print("🏍", separator: " ", terminator: " ")
                    Thread.sleep(forTimeInterval: 0.3)
                }
            }
        }
        
        let op = BlockOperation {
            autoreleasepool {
                for _ in 1..<100 {
                    guard !self.isCancelled else { return }
                    print("⛵️", separator: " ", terminator: " ")
                    Thread.sleep(forTimeInterval: 0.6)
                }
            }
        }
        backgroundQueue.addOperation(op)
        
        op.addExecutionBlock {
            autoreleasepool {
                for _ in 1..<100 {
                    guard !self.isCancelled else { return }
                    print("🚥", separator: " ", terminator: " ")
                    Thread.sleep(forTimeInterval: 0.5)
                }
            }
        }
        
        let op2 = CustomOperation(type: "⛱")
        backgroundQueue.addOperation(op2)
        
        op.completionBlock = {
            print("Done")
        }
    }
    
    @IBAction func cancelOperation(_ sender: Any) {
        isCancelled = true
        backgroundQueue.cancelAllOperations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancelOperation(self)
    }
    
    deinit {
        print(self, #function)
    }
}
