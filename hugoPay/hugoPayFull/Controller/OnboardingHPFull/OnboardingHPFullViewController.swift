//
//  OnboardingHPFullViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 27/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class OnboardingHPFullViewController: UIViewController {
    
    // Main Delegate
    weak var delegate: MainHPFullViewControllerDelegate?
    // TabBar controller
    var hugoTabController: UITabBarController?

    @IBOutlet weak var pageControlBox: UIView!
    @IBOutlet weak var hugoPayBtn: UIButton!
    @IBOutlet weak var scrollOnboarding: UIScrollView!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var logoTop: UIImageView!

    var pageControlBars: PageControlBarsHPFull = {
        let bars = PageControlBarsHPFull()
        bars.currentBarColor = .purpleTitle
        bars.barColor = .purpleTitleLight
        return bars
    }()
    
    lazy var viewModel: OnboardingHPFullViewModel = {
        return OnboardingHPFullViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hugoPayBtn.isHidden = true
        self.logoTop.isHidden = true
        
        hugoPayBtn.makeHugoPayFullButton(title: "Ingresar a HugoPay")
                
        let termsTextLocalized = String(format: "Conoce más acerca de hugoPay\n%@.", "ingresando aquí")
        
        let attributedTerms = NSAttributedString.title(
            termsTextLocalized,
            font: UIFont.init(name: Fonts.Book.rawValue, size: 13) ?? UIFont(),
            color: UIColor(red: 128.0 / 255.0, green: 120.0 / 255.0, blue: 140.0 / 255.0, alpha: 1.0),
            kern: 0
        )
        
        let mutableAttribuedTerms = NSMutableAttributedString(
            attributedString: attributedTerms
        )
        
        mutableAttribuedTerms.bold(
        "ingresando aquí",
        font: UIFont.init(name: Fonts.Bold.rawValue, size: 13) ?? UIFont())
        
        termsLabel.attributedText = mutableAttribuedTerms
        termsLabel.isUserInteractionEnabled = true
        
        let termsTap = UITapGestureRecognizer(target: self, action: #selector(didTapOnTermsAndConditionsAction(_:)))
        termsTap.numberOfTouchesRequired = 1
        termsTap.numberOfTapsRequired = 1
        termsLabel.addGestureRecognizer(termsTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configViewModel()
        viewModel.getOnboardingData()
        
//        if HugoPayData.shared.signUpGuestHugoPay {
//            HugoPayData.shared.signUpGuestHugoPay = false
//
//            if let vc = R.storyboard.hugoPay.createPinHugoPayViewController() {
//                vc.modalPresentationStyle = .fullScreen
//                vc.modalTransitionStyle = .crossDissolve
//                self.present(vc, animated: true, completion: nil)
//            }
//        }
    }

    func setupSlideScrollView(slides : [PageOnboardingHPFull]) {
        scrollOnboarding.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollOnboarding.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollOnboarding.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollOnboarding.addSubview(slides[i])
        }
        
        scrollOnboarding.delegate = self
        
        // New page control bars
        pageControlBars.numberOfPages = slides.count
        pageControlBars.currentPage = 0
        
        pageControlBars.frame = CGRect(x: 0, y: 0, width: pageControlBox.bounds.width, height: pageControlBox.bounds.height)
        pageControlBars.renderPageControlBars()
        pageControlBox.addSubview(pageControlBars)
    }

    func configViewModel(){
        viewModel.hideLoading = { [weak self] () in
            self?.hideLoading()
        }
        viewModel.showLoading = { [weak self] () in
            self?.showLoading()
        }
        viewModel.configureSlides = { [weak self] (slides) in
            self?.setupSlideScrollView(slides: slides)
        }
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goHugoPayFull(_ sender: Any) {
        self.dismiss(animated: true) {
            let vc = AlertCreateAccountHPFullViewController.instantiate(fromAppStoryboard: .CreateAccount)
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self.delegate
            vc.hugoTabController = self.hugoTabController
            self.hugoTabController?.present(vc, animated: true, completion: nil)
        }
    }

    @objc func didTapOnTermsAndConditionsAction(_ sender: UITapGestureRecognizer) {
        var termsWord = "terms"
        let spanishWord = "es"
        let deviceLang: String = Locale.current.languageCode ?? spanishWord
        
        if deviceLang != spanishWord {
            termsWord += "En"
        }
        
//        if let vc = R.storyboard.hugoPay.showTermsConditionsViewController() {
//            vc.modalPresentationStyle = .fullScreen
//            vc.modalTransitionStyle = .crossDissolve
//
//            self.present(vc, animated: true, completion: {
//                vc.loadContentWith(url: String(format: "https://hugo-pay-landing-2fntzxamka-uk.a.run.app/%@", termsWord))
//            })
//        }
    }
    
    func goToRegisterHugoPay(){
        goToTermsHugoPay()
    }
    
    func goToTermsHugoPay(){
//        if let vc = R.storyboard.hugoPay.createPinHugoPayViewController() {
//            self.present(vc, animated: true, completion: nil)
//        }
    }
    
    @IBAction func dismissOnboarding(_ sender: Any) {
        self.dismiss(animated: true) {
            let vc = AlertCreateAccountHPFullViewController.instantiate(fromAppStoryboard: .CreateAccount)
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self.delegate
            vc.hugoTabController = self.hugoTabController
            self.hugoTabController?.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func goMoreInfo(_ sender: Any) {
//        if let vc = R.storyboard.hugoPay.showTermsConditionsViewController() {
//            vc.modalPresentationStyle = .fullScreen
//            vc.modalTransitionStyle = .crossDissolve
//            
//            self.present(vc, animated: true, completion: {
//                vc.loadContentWith(url: String(format: "https://hugopay.io/terms"))
//            })
//        }
    }
}

extension OnboardingHPFullViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        if(Int(pageIndex) == 3) {
            self.hugoPayBtn.isHidden = false
        }else {
            self.hugoPayBtn.isHidden = true
        }
        pageControlBars.assignCurrentPage(index: Int(pageIndex))
        
        if pageIndex > 0 {
            self.logoTop.isHidden = false
        } else {
            self.logoTop.isHidden = true
        }
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        
        scrollView.contentOffset.y = 0.0
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        let slides = viewModel.getSlides()
        for (index,_) in slides.enumerated() {
            let min  = CGFloat(index/slides.count)
            let max = CGFloat((index+1)/slides.count)
            if !(index + 1 == slides.count){
                if(percentOffset.x > min && percentOffset.x <= max) {
                    slides[index].image.transform = CGAffineTransform(scaleX: (max-percentOffset.x)/max, y: (max-percentOffset.x)/max)
                    slides[index+1].image.transform = CGAffineTransform(scaleX: percentOffset.x/max, y: percentOffset.x/max)
                    
                }
            }
        }
        
    }
}
