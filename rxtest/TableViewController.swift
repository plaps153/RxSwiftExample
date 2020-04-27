//
//  TableViewController.swift
//  rxtest
//
//  Created by Hwangho Kim on 2020/01/02.
//  Copyright © 2020 lge. All rights reserved.
//

import UIKit
import RxSwift

class TableViewController: UITableViewController {

    var disposedBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // DistinctUntilChanged
        print("DistinctUntilChanged")
        Observable.from([1,2,2,2,3,4,5,5,5])
            .distinctUntilChanged()
            .subscribe { (result) in
                print(result)
        }.disposed(by: self.disposedBag)

        // Debounce
        print("Debounce")
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .take(10)
            //- 사용예제: 타이머를 2초로 지정해두면, 사용자가 버튼을 폭풍 누르다가 더이상 버튼을 안누르고 2초가 지날때 가장 마지막 클릭 이벤트를 준다.
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .debug("Debounce", trimOutput: false)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: self.disposedBag)


        // Skip
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .skip(3)
            .take(10)
            .debug("Skip", trimOutput: false)
            .subscribe().disposed(by: self.disposedBag)

        // StartWith
        Observable.from([1,2,3,4,5,6])
            .startWith(0)
            .debug("StartWith", trimOutput: false)
            .subscribe().disposed(by: self.disposedBag)

        // Concat
        let c = Observable.of(1,2,3,4,5)
        let d = Observable.of(4,5,6)
        c.concat(d)
            .debug("Concat", trimOutput: false)
            .subscribe {
                print($0)
        }.disposed(by: self.disposedBag)

        // CombineLatest
        let strOb = Observable.of("A", "B", "C")
        let intOb = Observable.of(0, 1, 2, 3)

        Observable.combineLatest(strOb, intOb) {
            "\($0) \($1)"
        }
        .subscribe {
            print($0)
        }.disposed(by: self.disposedBag)

        // SwitchLatest
        let aSubject = PublishSubject<String>()
        let bSubject = PublishSubject<String>()
        let switchTest = BehaviorSubject<Observable<String>>(value: aSubject)

        //Transforms an observable sequence of observable sequences into an observable sequence producing values only from the most recent observable sequence.
        // switchTest내에 최신 observable로 observable sequence를 바꾼다.
        // asubject가 switchTest에 최초 들어가 있어서 그쪽으로 onNext한 string을 출력하다가
        // bsubject를 넣으면 이제 bsubject로 transform되면서 b의 onNext한 string을 출력하게 된다.
        switchTest.switchLatest().subscribe{ event in print(event)}.disposed(by: self.disposedBag)

        aSubject.onNext("asub1")
        bSubject.onNext("asub1")

        switchTest.onNext(bSubject)
        aSubject.onNext("asub2")
        bSubject.onNext("asub2")

        // Zip
        let a = Observable.of(1,2,3,4,5)
        let b = Observable.of("a","b","c","d")
        Observable.zip(a,b){ return ($0,$1) }
            .debug("Zip", trimOutput: false)
            .subscribe {
                print($0)
        }.disposed(by: self.disposedBag)

        // Throttle
        print("Throttle")
        // 버튼을 누른 후 첫번 째 item을 emit하고 3초 동안은 갖고 오지 않는다. 그리고 3초 후의 latest item을 emit한다.
        Observable<Int>.interval(.seconds(2), scheduler: MainScheduler.instance)
            .take(10)
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .debug("throttle", trimOutput: false)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: self.disposedBag)

        // Filter
        print("Filter")
        Observable.of(2,30,22,5,60,1)
            .filter{$0 > 10}
            .subscribe(onNext:{
                print($0)
            }).disposed(by: self.disposedBag)

        // Scan
        Observable.of(1,2,3,4,5).scan(0) { seed, value in
            return seed + value
        }.subscribe(onNext:{
            print($0)
        }).disposed(by: self.disposedBag)


        // Buffer
        // 묶어서 방출, timeSpan은 maxmimum time interval (얼만큼 기다렸다가 방출할 것인지)
        // 시간이 초과되면 3개 이하라 할지라도 방출
        print("Buffer")
        Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .take(10)
            .buffer(timeSpan: DispatchTimeInterval.seconds(3), count: 3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { (result) in
                print(result)
            })
            .disposed(by: self.disposedBag)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)

        cell.selectionStyle = .none
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Subject"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "MVVM"
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "Operator - Scan"
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "showSubject", sender: nil)
        } else if indexPath.row == 1 {
            self.performSegue(withIdentifier: "showMVVM", sender: nil)
        } else if indexPath.row == 2 {
            self.performSegue(withIdentifier: "showOperator", sender: nil)
        }
    }
    

}
