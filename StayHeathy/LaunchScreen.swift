//
//  LaunchScreen.swift
//  StayHeathy
//
//  Created by Roi Kedarya on 24/02/2016.
//  Copyright © 2016 Roi Kedarya. All rights reserved.
//

import UIKit

class LaunchScreen: UIViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let navBar = self.navigationController?.navigationBar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: navBar!.frame.width, height: navBar!.frame.height))
        imageView.contentMode = .ScaleAspectFit
        let titleImage = UIImage(named: "topbartitle")
        let backgraundImage = UIImage(named: "topbarbg")
        let backButtonImage = UIImage(named: "")
        imageView.image = titleImage
        navBar?.setBackgroundImage(backgraundImage, forBarMetrics: UIBarMetrics.Default)
        navigationItem.titleView = imageView
        navBar?.backItem?.backBarButtonItem?.setBackButtonBackgroundImage(backButtonImage, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
    }
}
