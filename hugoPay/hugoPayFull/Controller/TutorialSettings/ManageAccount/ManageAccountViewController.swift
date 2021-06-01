//
//  ManageAccountViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 01/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class ManageAccountViewController: UIViewController {

    @IBOutlet weak var containerBox: UIView!
    @IBOutlet weak var buttonBox: UIView!

    lazy var viewModel: SettingsTutorialViewModel = {
        return SettingsTutorialViewModel()
    }()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        configureBoxes()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let mainVc = presentingViewController as? MainHPFullViewController {
            DispatchQueue.main.async {
                mainVc.loadMainInfo()
            }
        }
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
        buttonBox.layer.roundCorners(radius: buttonBox.frame.height/2)
        buttonBox.backgroundColor = UIColor.white
        // Dismiss Box
        containerBox.layer.roundCorners(radius: containerBox.frame.height/2)
        containerBox.layer.borderWidth = 1.0
        containerBox.layer.borderColor = UIColor(hex: "e2dded").cgColor
    }

    @IBAction func dismissTutorial(_ sender: Any) {
        self.updateTutorialTwo()
    }

    @IBAction func continueTutorial(_ sender: Any) {
        if let vc = R.storyboard.tutorialSettingsHPFull.securityTutorialViewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func backToMain() {
        self.dismiss(animated: true, completion: nil)
    }

    func updateTutorialTwo(){
            showLoading()
            viewModel.updateTutorialTwo().asObservable()
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
