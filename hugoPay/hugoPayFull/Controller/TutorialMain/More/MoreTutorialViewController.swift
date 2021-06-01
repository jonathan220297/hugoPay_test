//
//  MoreTutorialViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 01/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class MoreTutorialViewController: UIViewController {

    lazy var viewModel: TutorialOneViewModel = {
        return TutorialOneViewModel()
    }()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
    }

    func configViewModel() {
        viewModel.hideLoading = { [weak self] () in
            self?.hideLoading()
        }
        viewModel.showLoading = { [weak self] () in
            self?.showLoading()
        }
    }

    @IBAction func continueTutorial(_ sender: Any) {
        self.updateTutorialOne()
    }

    func backToMain() {
        self.dismiss(animated: true, completion: nil)
    }

    func updateTutorialOne(){
            showLoading()
            viewModel.updateTutorialOne().asObservable()
                .subscribe(onNext: {[weak self] (biometricsdata) in
                    guard let biometricsdata = biometricsdata else { return }
                    DispatchQueue.main.async {
                        self?.hideLoading()
                        if let success = biometricsdata.success, success {
                            self?.backToMain()
                        } else {
                            self?.backToMain()
                        }
                    }
                })
                .disposed(by: disposeBag)
    }
}
