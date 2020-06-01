//
//  OperatorViewController.swift
//  rxtest
//
//  Created by Hwangho Kim on 2020/04/27.
//  Copyright © 2020 lge. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OperatorViewController: UIViewController {

    var disposeBag = DisposeBag()

    // Scan operator
    @IBOutlet weak var lbScanOpResult: UILabel!
    @IBOutlet weak var btnScanOp: UIButton! {
        didSet {
            btnScanOp.rx.tap.scan(false) { [unowned self] (lastValue, newValue) in
                return self.execute(with: lastValue)
            }.subscribe(onNext: { (value) in
                print(value)
                self.lbScanOpResult.text = String(format: "Result %d", value)
            }).disposed(by: self.disposeBag)
        }
    }

    @IBOutlet weak var lbScanOpResult2: UILabel!

    @IBOutlet weak var lbScanOpResult3: UILabel!
    @IBOutlet weak var btnScanOp3: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnScanOp3.rx.tap.asDriver().scan(false) { lastValue, newValue in
            return !lastValue
        }.drive(self.lbScanOpResult3.rx.isHidden).disposed(by: self.disposeBag)
    }
    
    func execute(with value:Bool) -> Bool {
        print(value)
        return !value
    }

    @IBAction func btnScanOp2Action(_ sender: Any) {

        Observable.of(1,2,3,4,5).reduce(0, accumulator: +).subscribe(onNext: { (value) in
            if self.lbScanOpResult2 != nil {
                self.lbScanOpResult2.text = String(format: "Result %d", value)
            }
        }).disposed(by: self.disposeBag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
