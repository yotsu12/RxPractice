//
//  SimpleValidationViewController.swift
//  RxPractice
//
//  Created by 四柳 貴光 on 2018/12/11.
//  Copyright © 2018年 giiiita. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class SimpleValidationViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var button: UIButton!
    fileprivate let minimalUsernameLength: Int = 5
    fileprivate let minimalPasswordLength: Int = 5

    private let disposeBag: DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.usernameLabel.text = "Username has to be at least \(self.minimalUsernameLength) characters"
        self.passwordLabel.text = "Password has to be at least \(self.minimalPasswordLength) characters"

        let userNameValid = usernameTextField.rx.text.orEmpty
            .map { $0.count >= self.minimalUsernameLength }
            .share(replay: 1)

        let passwordValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= self.minimalPasswordLength }
            .share(replay: 1)

        let everythingValid = Observable.combineLatest(userNameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)

        userNameValid
            .bind(to: self.passwordTextField.rx.isEnabled)
            .disposed(by: self.disposeBag)

        userNameValid
            .bind(to: self.usernameLabel.rx.isHidden)
            .disposed(by: self.disposeBag)

        passwordValid
            .bind(to: self.passwordLabel.rx.isHidden)
            .disposed(by: self.disposeBag)

        everythingValid
            .bind(to: self.button.rx.isEnabled)
            .disposed(by: self.disposeBag)

        self.button.rx.tap
            .subscribe({ [weak self] _ in self?.showAlert() })
            .disposed(by: self.disposeBag)
    }

    func showAlert() {
        let alertView = UIAlertView(
            title: "RxExample",
            message: "This is wonderful",
            delegate: nil,
            cancelButtonTitle: "OK"
        )

        alertView.show()
    }

}

/*
 share(replay: 1): Hot変換(ConnectableObservableへ変換ということ？)
 subscribeしているobserverが複数存在していても全てのobserver間で共通化
 一つのストリームが分岐してそれぞれsbscribeした先に情報を伝達する
 mapで行なっている処理の複数callを一つにすることで無駄な計算を行わないようにする
*/
