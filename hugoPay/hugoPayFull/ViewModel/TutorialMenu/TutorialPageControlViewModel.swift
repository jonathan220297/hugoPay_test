//
//  TutorialPageControlViewModel.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 20/5/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class TutorialPageControlViewModel: NSObject {
    private let apiClient: APIClient = APIClient()
    var userManager = UserManager.shared
    var hugoPayData = HugoPayFullData.shared
    
    var collectionView: UICollectionView!
    var arrayPages: [HugoPayTutorialData] = []

    var changePageControlPosition: ((_ index: Int)->())?
    var dismissPageControl: (()->())?
    
    var actualIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    let pageCount = 5
    
    func changePositionByTap(for index: Int? = nil) {
        collectionView.isScrollEnabled = false
        if actualIndexPath.row < 4 {
            var row = 0
            if let index = index {
                row = index
                actualIndexPath = IndexPath(item: row, section: 0)
            } else {
                row = actualIndexPath.row + 1
            }
            guard let rect = self.collectionView.layoutAttributesForItem(at: IndexPath(row: row, section: 0))?.frame else {
                return
            }
            self.collectionView.scrollRectToVisible(rect, animated: true)
        } else {
            self.dismissPageControl?()
        }
        collectionView.isScrollEnabled = true
    }
    
    func updateTutorialStatus(for screen: Int, tutorialFinished: Bool? = false) -> BehaviorRelay<HugoPayTutorialUpdateStatusResponse?> {
         let apiResponse: BehaviorRelay<HugoPayTutorialUpdateStatusResponse?> = BehaviorRelay(value: nil)
         apiClient.sendPutHPFull(HugoPayTutorialUpdateStatusRequest(
            client_id: userManager.client_id ?? "",
            screen_number: screen,
            tutorial_finished: tutorialFinished ?? false
         )) { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let updateData):
                    apiResponse.accept(updateData)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        return apiResponse
    }
}

extension TutorialPageControlViewModel: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellTutorialPageNoImage", for: indexPath) as! TutorialPageWithoutImageCollectionViewCell
            
            cell.setTutorialPageDate(with: arrayPages[indexPath.row + 1])
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellTutorialPage", for: indexPath) as! TutorialPageCollectionViewCell
            
            cell.setTutorialPageDate(with: arrayPages[indexPath.row + 1])
            
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let indexPath = collectionView.indexPathForItem(at: center) {
            actualIndexPath = indexPath
            changePageControlPosition?(indexPath.row)
        }
    }
}
