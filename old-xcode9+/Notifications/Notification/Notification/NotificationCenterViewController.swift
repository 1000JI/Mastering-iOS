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

class NotificationCenterViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @objc func process(notification: Notification) {
        print(Thread.isMainThread ? "Main Thread" : "Background Thread")
        
        guard let value = notification.userInfo?["NewValue"] as? String else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.valueLabel.text = value
        }
        
        print("#1", #function)
    }
    
    var token: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1번째 방법
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(process(notification:)),
                                               name: Notification.Name.NewValueDidInput,
                                               object: nil)
        
        // 2번째 방법
        token = NotificationCenter.default.addObserver(forName: Notification.Name.NewValueDidInput,
                                               object: nil,
                                               queue: OperationQueue.main) { [weak self] (notification) in
            guard let value = notification.userInfo?["NewValue"] as? String else { return }

            self?.valueLabel.text = value

            print("#2 handling \(notification.name)")
        }
    }
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
        
        NotificationCenter.default.removeObserver(self)
        print(#function)
    }
}
