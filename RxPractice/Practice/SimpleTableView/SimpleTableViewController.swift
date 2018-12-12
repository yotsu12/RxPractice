//
//  SimpleTableViewController.swift
//  RxPractice
//
//  Created by 四柳 貴光 on 2018/12/12.
//  Copyright © 2018年 giiiita. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let disposeBag: DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        let items = Observable.just(
            (0..<20).map { "\($0)"}
        )

        items
            .bind(to: self.tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: self.disposeBag)

        self.tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext: { value in
                print("tap:\(value)")
            })
            .disposed(by: self.disposeBag)

        self.tableView.rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: { indexPath in
                print("Tapped Detail @ \(indexPath.section),\(indexPath.row)")
            })
            .disposed(by: disposeBag)

    }
}

/*
 ".bind(to: self.tableView.rx.items)":itemsに含まれる要素分cellが作成される
 ".modelSelected(String.self)":Cellが選択された時にイベント発火
 ".itemAccessoryButtonTapped":Cellに配置されているAccessoryButtonがタップされた時にイベント発火
*/
