//
//  ViewController.swift
//  InfinitePagingScrollView
//
//  Created by Tim Beals on 2017-12-17.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var scrollOptionsView: ScrollingOptionsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setupSubviews()
    }
    
    func setupSubviews() {
        
        self.scrollOptionsView = ScrollingOptionsView(frame: CGRect(x: 0, y: 300, width: self.view.bounds.width, height: 40))
        self.scrollOptionsView.delegate = self
        self.scrollOptionsView.datasource = ["option one", "option two", "option three", "option four"]
        
        view.addSubview(scrollOptionsView)
    }
}

extension ViewController: ScrollingOptionsViewDelegate {
    func optionChanged(to option: String) {
        
        print("delegate called")
    
    }
    
    
    
    
}

