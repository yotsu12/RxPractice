//
//  NumberViewController.swift
//  RxPractice
//
//  Created by 四柳 貴光 on 2018/12/11.
//  Copyright © 2018年 giiiita. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class NumberViewController: UIViewController {

    @IBOutlet weak var number1: UITextField!
    @IBOutlet weak var number2: UITextField!
    @IBOutlet weak var number3: UITextField!
    @IBOutlet weak var result: UILabel!

    private let disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        Observable.combineLatest(self.number1.rx.text.orEmpty, self.number2.rx.text.orEmpty, self.number3.rx.text.orEmpty)
        { textValue1, textValue2, textValue3 -> Int in
            return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
            }
            .map { $0.description }
            .bind(to: self.result.rx.text)
            .disposed(by: disposeBag)
    }
}

/*
 memo
 UITextFieldのObserverについて
 ".orEmpty": 空文字やnilの場合はobserveしない

 "combineLatest": それぞれ最後のシーケンスで発行した値を合成して新たにシーケンスを作成する
 どのシーケンスをどのように合成するかをクロージャの中に書くことが可能

 "map": ストリームの要素を変換し新たにストリームを作成する

 "bind": ストリームの要素をsubscribeし対象のUIに紐付ける

 "disposed": subscribeの破棄を管轄するDisposeBagを指定

 "DisposeBag": インスタンスがdeallocされたタイミングでsubscribeしたもの全てを解放する
 */

