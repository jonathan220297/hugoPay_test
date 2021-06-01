//
//  MenuHPFullViewController.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 01/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import UIKit

class MenuHPFullViewController: UIViewController {

    enum MenuItems: String {
        case qr
        case hugo_cash
        case money_requests
        case expense_control
        case recharge
        case payment
    }

    var menuTextHPFull: [MenuHPFull] = [MenuHPFull]()

    // PAGO SERVICIOS
    @IBOutlet weak var pagoServiciosView: UIView!
    @IBOutlet weak var pagoServiciosText: UILabel!
    @IBOutlet weak var pagoServiciosImage: UIImageView!

    // RECARGAS DE SALDO
    @IBOutlet weak var recargasSaldoView: UIView!
    @IBOutlet weak var recargasSaldoText: UILabel!
    @IBOutlet weak var recargasSaldoImage: UIImageView!

    // CONTROL GASTOS
    @IBOutlet weak var controlGastosView: UIView!
    @IBOutlet weak var controlGastosText: UILabel!
    @IBOutlet weak var controlGastosImage: UIImageView!

    // SOLICITUDES
    @IBOutlet weak var solicitudesView: UIView!
    @IBOutlet weak var solicitudesText: UILabel!
    @IBOutlet weak var solicitudesImage: UIImageView!

    // HUGO CASH
    @IBOutlet weak var hugoCashView: UIView!
    @IBOutlet weak var hugoCashText: UILabel!
    @IBOutlet weak var hugoCashImage: UIImageView!

    // PAGO QR
    @IBOutlet weak var pagoQRView: UIView!
    @IBOutlet weak var pagoQRText: UILabel!
    @IBOutlet weak var pagoQRImage: UIImageView!

    lazy var viewModel: MenuViewModel = {
        return MenuViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configMenu()
    }

    func configMenu() {
        for menuItem in menuTextHPFull {
            if let menuType = MenuItems.init(rawValue: menuItem.type ?? "") {
              switch menuType {
                case .qr:
                    pagoQRText.text = menuItem.text
                case .hugo_cash:
                    hugoCashText.text = menuItem.text
                case .money_requests:
                    solicitudesText.text = menuItem.text
                case .expense_control:
                    controlGastosText.text = menuItem.text
                case .recharge:
                    recargasSaldoText.text = menuItem.text
                case .payment:
                    pagoServiciosText.text = menuItem.text
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkTutorial()
    }

    func checkTutorial() {
        if !viewModel.getTutorialThree() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if let vc = R.storyboard.tutorialMenu.instantiateInitialViewController() {
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func closeMenu(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
