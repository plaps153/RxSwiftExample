//
//  NetworkViewController.swift
//  rxtest
//
//  Created by Hwangho Kim on 2020/01/02.
//  Copyright © 2020 lge. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NetworkViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var model: ViewModel = ViewModel()

    var disposedBag = DisposeBag()
    
    let searchVC: UISearchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar {
        return searchVC.searchBar
    }

    var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchVC()

        searchBar.rx.text.orEmpty.bind(to: model.searchText).disposed(by: self.disposedBag)

        model.data.drive(self.tableView.rx.items(cellIdentifier: "ResultCells")) {_, repository, cell in
            cell.textLabel?.text = repository.repoName
            cell.detailTextLabel?.text = repository.repoURL
        }.disposed(by: self.disposedBag)

        model.searchText.asObserver().subscribe { [weak self] (event) in
            if let e = event.element {
                self?.navigationController?.title = e
            }
        }.disposed(by: self.disposedBag)
    }

    private func configureSearchVC() {
        searchVC.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = true
        searchBar.text = "NavdeepSinghh"
        searchBar.placeholder = "Enter GitHub ID, e.g., \"NavdeepSinghh\""
        tableView.tableHeaderView = searchBar
        definesPresentationContext = true
    }
}
