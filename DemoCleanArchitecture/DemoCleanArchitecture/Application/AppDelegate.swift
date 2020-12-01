//
//  AppDelegate.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/9/16.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  private let bag = DisposeBag()

  let appDIContainer = AppDIContainer()
  var appFlowCoordinator: AppFlowCoordinator?

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    window = UIWindow(frame: UIScreen.main.bounds)

    let tabBarController = UITabBarController()
    appFlowCoordinator = AppFlowCoordinator(tabBarController: tabBarController, appDIContainer: appDIContainer)

    window?.rootViewController = tabBarController
    window?.makeKeyAndVisible()

    appFlowCoordinator?.start()
      .subscribe()
      .disposed(by: bag)
    
    return true
  }
}

