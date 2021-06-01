//
//  TutorialInitialPageViewController.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 18/5/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift
import Nuke

class TutorialInitialPageViewController: UIViewController {
    @IBOutlet weak var imageViewTutorial: UIImageView!
    @IBOutlet weak var labelTitleTutorial: UILabel!
    @IBOutlet weak var labelDescriptionTutorial: UILabel!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var buttonSkip: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    lazy var viewModel: TutorialHugoPayFullViewModel = {
        return TutorialHugoPayFullViewModel()
    }()
    
    var disposeBag = DisposeBag()
    var tutorialDataGlobal: [HugoPayTutorialData] = []
    var tutorialReadCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        fetchTutorialData()
        fetchTutorialStatus()
    }
    
    // MARK: - Actions
    @IBAction func buttonStartTapped(_ sender: UIButton) {
        if let vc = R.storyboard.hugoPayFullTutorial.tutorialPageControllerViewController() {
            vc.modalPresentationStyle = .fullScreen
            vc.tutorialDataGlobal = tutorialDataGlobal
            vc.tutorialPageReadCount = tutorialReadCount
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func buttonSkipTapped(_ sender: UIButton) {
        goToCashIn()
    }
    
    // MARK: - Functions
    fileprivate func configureViewModel() {
        viewModel.showLoading = {[weak self] in
            self?.showLoading()
        }
        viewModel.hideLoading = {[weak self] in
            self?.hideLoading()
        }
    }
    
    fileprivate func fetchTutorialData() {
        self.showLoading()
        viewModel.getTutorialDataHugoPay()
            .asObservable()
            .subscribe(onNext: {[weak self] response in
                self?.hideLoading()
                guard let response = response else {return}
                if let success = response.success, success, let data = response.data {
                    print(response)
                    self?.tutorialDataGlobal = data
                    let dataTutorial = data.first { tutorial in
                        tutorial.page == 1
                    }
                    self?.configureTutorialData(with: dataTutorial ?? nil)
                }
            }, onError: { error in
                
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func fetchTutorialStatus() {
        viewModel.getTutorialStatus()
            .asObservable()
            .subscribe(onNext: {[weak self] response in
                guard let response = response else {
                    return
                }
                if let success = response.success, success, let dataCount = response.data?.count {
                    self?.tutorialReadCount = dataCount
                }
            }, onError: { error in
                showGeneralErrorCustom(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func updateTutorialStatus(with page: Int, tutorialFinished: Bool? = false) {
        viewModel.updateTutorialStatus(for: page, tutorialFinished: tutorialFinished)
            .asObservable()
            .subscribe(onNext: { result in
                print(result)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func configureTutorialData(with data: HugoPayTutorialData?) {
        if let urlString = data?.image, urlString != "", let url = URL(string: urlString) {
            Nuke.loadImage(with: url, into: imageViewTutorial)
        }
        let titleTutorial = data?.title?.text ?? ""
        labelTitleTutorial.attributedText = titleTutorial.withBoldText(text: data?.title?.bold?.first ?? "", font: R.font.gothamHTFBook(size: 17), fontColorBold: .white)
        labelDescriptionTutorial.text = data?.content?.first?.text ?? ""
        let lastIndex = data?.content?.endIndex ?? 0
        buttonContinue.setTitle((data?.content?[lastIndex - 2].text ?? "").uppercased(), for: .normal)
        buttonSkip.setTitle((data?.content?.last?.text ?? "").uppercased(), for: .normal)
    }
    
    fileprivate func goToCashIn() {
        updateTutorialStatus(with: 1, tutorialFinished: true)
        let vc = TutorialDoCashInViewController.instantiate(fromAppStoryboard: .HugoPayFullTutorial)
        vc.modalPresentationStyle = .fullScreen
        vc.tutorialDataGlobal = tutorialDataGlobal
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
