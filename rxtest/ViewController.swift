//
//  ViewController.swift
//  rxtest
//
//  Created by Hwangho Kim on 2019/12/26.
//  Copyright © 2019 lge. All rights reserved.
//

import UIKit
import RxSwift

class TableVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class ViewController: UIViewController {

    let disposedBag: DisposeBag = DisposeBag()
    var array:[Int] = [Int]()
    var b:[Int] {
        return [Int]()
    }

    var c:[Int] = {
        return [3]
    }()

    lazy var d:[Int] = {
        return [3]
    }()

    var asyncSubject:AsyncSubject<Int> = AsyncSubject<Int>()
    var publishSubject: PublishSubject<Int> = PublishSubject<Int>()
    var behaviorSubject: BehaviorSubject<Int> = BehaviorSubject<Int>(value: 0)
    var replaySubject: ReplaySubject<Int> = ReplaySubject<Int>.create(bufferSize: 100)

    var asyncSubjectDisposable: Disposable?
    var publishSubjectDisposable: Disposable?
    var behaviorSubjectDisposable: Disposable?
    var relaySubjectDisposable: Disposable?

    @IBOutlet weak var t4: UITextView!
    @IBOutlet weak var t3: UITextView!
    @IBOutlet weak var t2: UITextView!
    @IBOutlet weak var t1: UITextView!

    @IBOutlet weak var board: UITextView!

    var disposable: Disposable?

    override func viewDidLoad() {
        super.viewDidLoad()

        var i:Int = 0
        DispatchQueue.global().async {
            while(true) {

                self.asyncSubject.onNext(i)
                self.publishSubject.onNext(i)
                self.behaviorSubject.onNext(i)
                self.replaySubject.onNext(i)
                i += 1

                DispatchQueue.main.async { [weak self] in
                    self?.board.text.append(String(i))
                }
                sleep(1)
            }
        }

        Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        .take(10)
            .bind(to: self.asyncSubject)
            .disposed(by: self.disposedBag)

        self.asyncSubject
            .debug()
            .subscribe()
            .disposed(by: self.disposedBag)
    }

    @IBAction func btn1(_ sender: Any) {
        if (sender as! UISwitch).isOn == true {
            asyncSubjectDisposable =  asyncSubject.observeOn(MainScheduler.instance).subscribe({ (event) in
                if let element = event.element {
                    self.t1.text.append(String(element) + "\n")
                }
            })
            asyncSubjectDisposable?.disposed(by: self.disposedBag)
        } else {
            t1.text = ""
            asyncSubjectDisposable?.dispose()
        }
    }

    @IBAction func btn2(_ sender: Any) {
        if (sender as! UISwitch).isOn == true {
            publishSubjectDisposable = publishSubject.observeOn(MainScheduler.instance).subscribe({ (event) in
                self.t2.text.append(String(event.element!) + "\n")
            })

            publishSubjectDisposable?.disposed(by: self.disposedBag)
        } else {
            t2.text = ""
            publishSubjectDisposable?.dispose()
        }
    }

    @IBAction func btn3(_ sender: Any) {
        if (sender as! UISwitch).isOn == true {
            behaviorSubjectDisposable = behaviorSubject.observeOn(MainScheduler.instance).subscribe({ (event) in
                self.t3.text.append(String(event.element!) + "\n")
            })

            behaviorSubjectDisposable?.disposed(by: self.disposedBag)
        } else {
            t3.text = ""
            behaviorSubjectDisposable?.dispose()
        }
    }

    @IBAction func btn4(_ sender: Any) {
        if (sender as! UISwitch).isOn == true {
            relaySubjectDisposable =  replaySubject.observeOn(MainScheduler.instance).subscribe({ (event) in
                self.t4.text.append(String(event.element!) + "\n")
            })

            relaySubjectDisposable?.disposed(by: self.disposedBag)
        } else {
            t4.text = ""
            relaySubjectDisposable?.dispose()
        }
    }

    @IBAction func stopAction(_ sender: Any) {
        self.asyncSubject.onCompleted()
    }
}

