//
//  UIViewController+Ext.swift
//  FintrackApp
//
//  Created by Edgar Arlindo on 23/02/25.
//

import UIKit

extension UIViewController {
    func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
