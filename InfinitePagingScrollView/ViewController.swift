//
//  ViewController.swift
//  InfinitePagingScrollView
//
//  Created by Tim Beals on 2017-12-17.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var infiniteScrollView = InfiniteScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        infiniteScrollView.removeFromSuperview()
        
        self.infiniteScrollView = InfiniteScrollView(frame: CGRect(x: 0, y: 300, width: self.view.bounds.width, height: 40))
        
        view.addSubview(infiniteScrollView)
        
        self.infiniteScrollView.delegate = self
        self.infiniteScrollView.datasource = ["option one", "option two", "option three", "option four"]

    }
    
}

extension ViewController: InfiniteScrollViewDelegate {

    func optionChanged(to option: String) {
        print("delegate called with option: \(option)")
    }

}

