//
//  ViewController.swift
//  RxPractice
//
//  Created by 四柳 貴光 on 2019/01/04.
//  Copyright © 2019年 giiiita. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController {

    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        let helloWorldSubject = PublishSubject<String>()

        helloWorldSubject
            .subscribe(onNext: { message in
                print("onNext:\(message)")
            }, onCompleted: {
                print("onCompleted")
            }, onDisposed: {
                print("onDisposed")
            })
            .disposed(by: self.disposeBag)

        helloWorldSubject.onNext("helloWorld")
        helloWorldSubject.onNext("helloWorld")
        helloWorldSubject.onCompleted()
    }
}
