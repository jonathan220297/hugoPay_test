//
//  TutorialPageControllerViewController.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 20/5/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import RxSwift


class TutorialPageControllerViewController: UIViewController {
    @IBOutlet weak var collectionViewPages: UICollectionView!
    @IBOutlet weak var stackViewPages: UIStackView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    lazy var viewModel: TutorialPageControlViewModel = {
        return TutorialPageControlViewModel()
    }()
    
    var tutorialDataGlobal: [HugoPayTutorialData] = []
    var tutorialPageReadCount = 0
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureOptionsCollectionView()
        configureTapGesture()
        configureTutorialPageInit()
    }
    
    // MARK: - Observers
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        viewModel.changePositionByTap()
    }
    
    // MARK: - Actions
    @IBAction func buttonSkipTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Functions
    func configureViewModel() {
        viewModel.arrayPages = tutorialDataGlobal
        
        viewModel.changePageControlPosition = {[weak self] index in
            print("Index: \(index)")
            self?.changePageControlPosition(with: index)
        }
        
        viewModel.dismissPageControl = {[weak self] in
            self?.dismissTutorialPage()
        }
    }
    
    func configureOptionsCollectionView() {
        self.collectionViewPages.backgroundColor = UIColor.clear

        self.collectionViewPages.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        collectionViewPages.register(UINib(nibName: "TutorialPageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellTutorialPage")
        collectionViewPages.register(UINib(nibName: "TutorialPageWithoutImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellTutorialPageNoImage")

        viewModel.collectionView = collectionViewPages
        self.collectionViewPages.dataSource = self.viewModel
        self.collectionViewPages.delegate = self.viewModel
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let width = collectionViewPages.bounds.width
        let height = collectionViewPages.bounds.height
        layout.itemSize = CGSize(width: width , height: height )
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionViewPages.isPagingEnabled = true
        collectionViewPages.collectionViewLayout = layout
    }
    
    fileprivate func configureTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
    
    fileprivate func configureTutorialPageInit() {
        if tutorialPageReadCount > 0 {
//            self.changePageControlPosition(with: tutorialPageReadCount - 1)
////            viewModel.changePositionByTap(for: tutorialPageReadCount - 1)
//            collectionViewPages.isScrollEnabled = false
////            guard let rect = self.collectionViewPages.layoutAttributesForItem(at: IndexPath(row: tutorialPageReadCount - 1, section: 0))?.frame else {
////                return
////            }
////            self.collectionViewPages.scrollRectToVisible(rect, animated: true)
//            self.collectionViewPages.scrollToItem(at: IndexPath(row: tutorialPageReadCount - 1, section: 0), at: .centeredHorizontally, animated: true)
//            collectionViewPages.isScrollEnabled = true
        } else {
            updateTutorialStatus(for: 1)
        }
    }
    
    fileprivate func changePageControlPosition(with index: Int) {
        var i = 0
        stackViewPages.subviews.forEach { (view) in
            if i == index {
                view.backgroundColor = .greenMint
            } else {
                view.backgroundColor = .strongPurple1
            }
            i += 1
        }
        updateTutorialStatus(for: index)
    }
    
    fileprivate func updateTutorialStatus(for index: Int, tutorialFinished: Bool? = false) {
        viewModel.updateTutorialStatus(for: index + 1, tutorialFinished: tutorialFinished)
            .asObservable()
            .subscribe(onNext: {[weak self] result in
                print(result)
            }, onError: {[weak self] error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func dismissTutorialPage() {
        //Call webservice
        updateTutorialStatus(for: 6, tutorialFinished: true)
        let vc = TutorialDoCashInViewController.instantiate(fromAppStoryboard: .HugoPayFullTutorial)
        vc.modalPresentationStyle = .fullScreen
        vc.tutorialDataGlobal = tutorialDataGlobal
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
