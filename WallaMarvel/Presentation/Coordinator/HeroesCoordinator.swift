//
//  HeroesCoordinator.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import Foundation
import UIKit
import SwiftUI

final class HeroesCoordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    @available(iOS 15.0, *)
    func start() {
        let listView = HeroesListView()
        let hostingVC = UIHostingController(rootView: listView)
        navigationController.pushViewController(hostingVC, animated: false)
    }
}
