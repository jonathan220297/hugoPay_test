//
//  WelcomeHPFullViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 31/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class WelcomeHPFullViewController: UIViewController {

    @IBOutlet weak var continueBox: UIView!
    @IBOutlet weak var dismissBox: UIView!

    lazy var viewModel: TutorialOneViewModel = {
        return TutorialOneViewModel()
    }()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        configureBoxes()
    }

    func configViewModel() {
        viewModel.hideLoading = { [weak self] () in
            self?.hideLoading()
        }
        viewModel.showLoading = { [weak self] () in
            self?.showLoading()
        }
    }

    func configureBoxes() {
        // Continue Box
        continueBox.layer.roundCorners(radius: continueBox.frame.height/2)
        continueBox.backgroundColor = UIColor.white
        let tapContinue = UITapGestureRecognizer(target: self, action: #selector(continueTutorial))
        continueBox.isUserInteractionEnabled = true
        continueBox.addGestureRecognizer(tapContinue)
        // Dismiss Box
        dismissBox.layer.roundCorners(radius: dismissBox.frame.height/2)
        dismissBox.layer.borderWidth = 1.0
        dismissBox.layer.borderColor = UIColor(hex: "e2dded").cgColor
        let tapDismiss = UITapGestureRecognizer(target: self, action: #selector(dismissTutorial))
        dismissBox.isUserInteractionEnabled = true
        dismissBox.addGestureRecognizer(tapDismiss)
    }

    @objc func continueTutorial() {
        if let vc = R.storyboard.tutorialHPFull.virtualCardViewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func dismissTutorial() {
        self.updateTutorialOne()
    }

    func backToMain() {
        self.dismiss(animated: true, completion: nil)
    }

    func updateTutorialOne(){
            showLoading()
            viewModel.updateTutorialOne().asObservable()
                .subscribe(onNext: {[weak self] (biometricsdata) in
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
