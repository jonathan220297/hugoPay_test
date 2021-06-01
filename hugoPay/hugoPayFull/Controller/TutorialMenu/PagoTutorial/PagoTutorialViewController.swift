//
//  PagoTutorialViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 02/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class PagoTutorialViewController: UIViewController {

    lazy var viewModel: TutorialMenuViewModel = {
        return TutorialMenuViewModel()
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
        self.updateTutorialThree()
    }

    @IBAction func updateTutorialThree(_ sender: Any) {
        self.updateTutorialThree()
    }

    func backToMain() {
        self.dismiss(animated: true, completion: nil)
    }

    func updateTutorialThree(){
            showLoading()
            viewModel.updateTutorialThree().asObservable()
                .subscribe(onNext: {[weak self] (biometricsdata) in
                    guard biometricsdata != nil else { return }
                    DispatchQueue.main.async {
                        self?.hideLoading()
                        self?.getTutorialSteps()
                    }
                })
                .disposed(by: disposeBag)
    }

    func getTutorialSteps() {
        showLoading()
        viewModel.getTutorialSteps().asObservable()
            .subscribe(onNext: {[weak self] (steps) in
                DispatchQueue.main.async {
                    self?.hideLoading()
                    self?.backToMain()
                }
            })
            .disposed(by: disposeBag)
    }
}
