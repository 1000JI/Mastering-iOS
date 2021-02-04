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

class PropertyAnimatorViewController: UIViewController {
    
    @IBOutlet weak var redView: UIView!
    
    var animator: UIViewPropertyAnimator?
    
    func moveAndResize() {
        let targetFrame = CGRect(x: view.center.x - 100, y: view.center.y - 100, width: 200, height: 200)
        redView.frame = targetFrame
    }
    
    @IBAction func reset(_ sender: Any?) {
        redView.backgroundColor = UIColor.red
        redView.frame = CGRect(x: 50, y: 100, width: 50, height: 50)
    }
    
    @IBAction func pause(_ sender: Any) {
        animator?.pauseAnimation()
        print(#function, animator?.fractionComplete ?? 0.0) // 실행 비율 출력
    }
    
    @IBAction func animate(_ sender: Any) {
        // First Usage
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 7,
                                                       delay: 0,
                                                       options: [],
                                                       animations: {
                                                        self.moveAndResize()
                                                       },
                                                       completion: { position in
                                                        switch position {
                                                        case .end:
                                                            print("End")
                                                        case .start:
                                                            print("Start")
                                                        case .current:
                                                            print("Current")
                                                        }
                                                       })
        
        // Second Usage
        animator = UIViewPropertyAnimator(duration: 7,
                                          curve: .linear,
                                          animations: {
                                            self.moveAndResize()
                                          })
        
        animator?.addCompletion({ (position) in
            print("DONE \(position)")
        })
    }
    
    @IBAction func resume(_ sender: Any) {
        animator?.startAnimation()
    }
    
    @IBAction func stop(_ sender: Any) {
        animator?.stopAnimation(false)
        animator?.finishAnimation(at: .current)
        /*
         true -> Animation을 중지하고 별도의 마무리 작업 없이 Inactive 상태로 전환 한다.
         false -> Stopped 상태로 전환하며 Finish Method를 이어서 호출하게 된다.
            Completion Handler가 호출 되고, Inactive 상태가 된다.
         */
    }
    
    @IBAction func add(_ sender: Any) {
        animator?.addAnimations({
            /*
             Inactive -> 원본 Animation과 동일한 시간 동안 실행된다.
             Active -> 남은 시간 동안 실행 된다.
             Stop -> Crush 발생하므로 주의가 필요하다.
             */
            self.redView.backgroundColor = .blue
        }, delayFactor: 0) // Animation 지연 비율 (0: 지연 없이 실행)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
