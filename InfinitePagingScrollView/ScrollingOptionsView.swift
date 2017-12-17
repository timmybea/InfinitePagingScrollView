//
//  ScrollingOptionsView.swift
//  InfinitePagingScrollView
//
//  Created by Tim Beals on 2017-12-17.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol ScrollingOptionsViewDelegate {
    func optionChanged(to option: String)
}

class ScrollingOptionsView: UIView {

    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = UIColor.red
        scroll.showsHorizontalScrollIndicator = false
        scroll.bounces = true
        scroll.isPagingEnabled = true
        return scroll
    }()
    
    let tapView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var datasource: [String]? {
        didSet {
            setupContentView()
        }
    }
    
    private var input: [String]?
    
    var selectedOption: String! {
        didSet {
            print("SELECTED: \(selectedOption)")
            self.delegate?.optionChanged(to: selectedOption)
        }
    }
    
    var delegate: ScrollingOptionsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.gray
        scrollView.delegate = self
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        
        scrollView.frame = CGRect(x: (self.bounds.width / 2),
                                  y: 0,
                                  width: (self.bounds.width / 2),
                                  height: self.bounds.height)
        self.addSubview(scrollView)
        
        tapView.frame = self.bounds
        self.addSubview(tapView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didReceiveTap(sender:)))
        tapView.addGestureRecognizer(tapGesture)
        
    }
    
    private func setupContentView() {
        
        guard var tempInput = datasource else { return }
        
        let firstLast = (tempInput.first, tempInput.last)
        tempInput.append(firstLast.0!)
        tempInput.insert(firstLast.1!, at: 0)
        self.input = tempInput
        
        self.scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(self.input!.count),
                                             height: scrollView.frame.size.height)
        
        for i in 0..<self.input!.count {
            var frame = CGRect()
            frame.origin.x = scrollView.frame.size.width * CGFloat(i)
            frame.origin.y = 0
            frame.size = scrollView.frame.size
            
            let label = UILabel(frame: frame)
            label.text = self.input![i]
            self.scrollView.addSubview(label)
        }
        scrollView.contentOffset = CGPoint(x: scrollView.frame.width, y: 0)
        let index = Int(scrollView.contentOffset.x / scrollView.frame.width) - 1
//        index = index < datasource!.count - 1 ? index : 0
        self.selectedOption = datasource![index]
    }
    
    @objc
    func didReceiveTap(sender: UITapGestureRecognizer) {
        print("RECEIVED TAP!")
        
        var index = Int(scrollView.contentOffset.x / scrollView.frame.width)
        index = index < datasource!.count ? index : 0
        print("INDEX IS \(index)")
        self.selectedOption = datasource![index]
 
        let x = scrollView.contentOffset.x
        let nextRect = CGRect(x: x + scrollView.frame.width,
                              y: 0,
                              width: scrollView.frame.width,
                              height: scrollView.frame.height)
        
        scrollView.scrollRectToVisible(nextRect, animated: true)
    }
}

extension ScrollingOptionsView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.input != nil else { return }
        let x = scrollView.contentOffset.x
        if x >=  scrollView.frame.size.width * CGFloat(self.input!.count - 1) {
            self.scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width , y: 0)
        } else if x < scrollView.frame.width {
            self.scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width * CGFloat(self.input!.count - 2), y: 0)
        }
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

//    }

}
