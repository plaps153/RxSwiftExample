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
            btnScanOp.rx.tap.scan(false) { lastValue, newValue in
                return !lastValue
            }.subscribe(onNext: { (value) in
                print(value)
                self.lbScanOpResult.text = String(format: "Result %d", value)
            }).disposed(by: self.disposeBag)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
