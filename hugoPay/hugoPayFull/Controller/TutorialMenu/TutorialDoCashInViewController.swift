//
//  TutorialDoCashInViewController.swift
//  Hugo
//
//  Created by Jonathan  Rodriguez on 26/5/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit
import Nuke

class TutorialDoCashInViewController: UIViewController {
    @IBOutlet weak var imageViewTutorial: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var buttonDoCashIn: UIButton!
    
    var tutorialDataGlobal: [HugoPayTutorialData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTutorialData(with: tutorialDataGlobal.last)
    }
    
    // MARK: - Actions
    @IBAction func buttonDismissTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func buttonDoCashin(_ sender: UIButton) {
        dismiss(animated: true) {
            NotificationCenter.default.post(name: .showCashinFromTutorial, object: nil)
        }
    }
    
    // MARK: - Functions
    fileprivate func configureTutorialData(with data: HugoPayTutorialData?) {
        if let urlString = data?.image, urlString != "", let url = URL(string: urlString) {
            Nuke.loadImage(with: url, into: imageViewTutorial)
        }
        let titleTutorial = data?.title?.text ?? ""
        labelTitle.text = titleTutorial
        labelSubtitle.text = data?.content?.first?.text ?? ""
        buttonDoCashIn.setTitle((data?.content?.last?.text ?? "").uppercased(), for: .normal)
    }
}
