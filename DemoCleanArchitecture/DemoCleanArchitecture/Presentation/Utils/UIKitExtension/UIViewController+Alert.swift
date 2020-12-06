//
//  UIViewController+Alert.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/12/6.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit

extension UIViewController {
  func alert(title: String?, message: String?, action: ((UIAlertAction) -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let ok = UIAlertAction(title: "確認", style: .default, handler: action)
    alert.addAction(ok)

    present(alert, animated: true, completion: nil)
  }
}
