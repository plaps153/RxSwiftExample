//
//  ViewModel.swift
//  rxtest
//
//  Created by Hwangho Kim on 2020/01/02.
//  Copyright © 2020 lge. All rights reserved.
//

import RxSwift
import RxCocoa

struct ViewModel {
    let searchText: BehaviorSubject<String> = BehaviorSubject(value: "")

    lazy var data: Driver<[Repository]> = {
        return self.searchText
            .asObservable()
            .throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest(ViewModel.repositoriesBy(_:))
            .asDriver(onErrorJustReturn: [])
    }()

    static func repositoriesBy(_ githubID: String) -> Observable<[Repository]> {
        guard !githubID.isEmpty,
            let url = URL(string: "https://api.github.com/users/\(githubID)/repos") else {
                return Observable.just([])
        }

        return URLSession.shared.rx.json(url: url)
            .retry(3)
            //.catchErrorJustReturn([])
            .map(parse)
    }

    static func parse(json: Any) -> [Repository] {
        guard let items = json as? [[String: Any]]  else {
            return []
        }

        var repositories = [Repository]()

        items.forEach{
            guard let repoName = $0["name"] as? String,
                let repoURL = $0["html_url"] as? String else {
                    return
            }
            repositories.append(Repository(repoName: repoName, repoURL: repoURL))
        }
        return repositories
    }
}
