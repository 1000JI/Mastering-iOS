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

class ViewTransitionViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var blueView: UIView!
    
    @IBAction func startTransition(_ sender: Any) {
//        UIView.transition(with: containerView,
//                          duration: 1,
//                          options: [.transitionCurlUp],
//                          animations: {
//                            self.redView.isHidden.toggle()
//                            self.blueView.isHidden.toggle()
//                          },
//                          completion: nil)
        
        UIView.transition(from: redView, // 제거 할 View
                          to: blueView, // 추가 할 View
                          duration: 1,
                          options: [.transitionFlipFromLeft, .showHideTransitionViews],
                          completion: { finished in
                            UIView.transition(from: self.blueView,
                                              to: self.redView,
                                              duration: 1,
                                              options: [.transitionFlipFromRight, .showHideTransitionViews],
                                              completion: nil)
                          })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
