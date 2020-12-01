//
//  UIViewController+Rx.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/11/27.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
  var viewDidLoad: ControlEvent<Void> {
    let source = methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
    return ControlEvent(events: source)
  }

  var viewWillAppear: ControlEvent<Bool> {
    let source = sentMessage(#selector(Base.viewWillAppear(_:))).map { $0.first as? Bool ?? false }
    return ControlEvent(events: source)
  }

  var viewDidAppear: ControlEvent<Bool> {
    let source = methodInvoked(#selector(Base.viewDidAppear(_:))).map { $0.first as? Bool ?? false }
    return ControlEvent(events: source)
  }

  var viewWillDisappear: ControlEvent<Bool> {
    let source = methodInvoked(#selector(Base.viewWillDisappear(_:))).map { $0.first as? Bool ?? false }
    return ControlEvent(events: source)
  }

  var viewDidDisappear: ControlEvent<Bool> {
    let source = methodInvoked(#selector(Base.viewDidDisappear(_:))).map { $0.first as? Bool ?? false }
    return ControlEvent(events: source)
  }
}
