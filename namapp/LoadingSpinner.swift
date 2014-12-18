//
//  ShowLoadingSpinner.swift
//  namapp
//
//  Created by Boyd Dames on 17-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

class LoadingSpinner {
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func startLoadingSpinner(view: UIView) {
        container.frame = view.frame
        container.center = view.center

        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = view.center
        loadingView.backgroundColor = UIColor.colorWithRGBHexWithAlpha(0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.roundedCorners(20)

        
        spinner.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        spinner.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.WhiteLarge
        spinner.center = CGPointMake(loadingView.frame.size.width / 2,
            loadingView.frame.size.height / 2);
        loadingView.addSubview(spinner)
        container.addSubview(loadingView)
        view.addSubview(container)
        spinner.startAnimating()
    }
    
    func stopLoadingSpinner() {
        spinner.stopAnimating()
        container.removeFromSuperview()
    }
}
