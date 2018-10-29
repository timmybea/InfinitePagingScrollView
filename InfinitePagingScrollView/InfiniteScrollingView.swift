//
//  InfiniteScrollingView.swift
//  InfinitePagingScrollView
//
//  Created by Tim Beals on 2018-10-25.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit

protocol InfiniteScrollViewDelegate {
    func optionChanged(to option: String)
}

class InfiniteScrollView: UIView {
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = UIColor.red
        scroll.showsHorizontalScrollIndicator = false
        scroll.bounces = false
        scroll.isPagingEnabled = true
        return scroll
    }()
    
    lazy var tapView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didReceiveTap(sender:)))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    var datasource: [String]? {
        didSet {
            modifyDatasource()
        }
    }
    
    private var _datasource: [String]? {
        didSet {
            setupContentView()
        }
    }
    
    var selectedOption: String! {
        didSet {
            self.delegate?.optionChanged(to: selectedOption)
        }
    }

    var delegate: InfiniteScrollViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.gray
        scrollView.delegate = self
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupSubviews() {
        scrollView.frame = CGRect(x: (self.bounds.width / 2),
                                  y: 0,
                                  width: (self.bounds.width / 2),
                                  height: self.bounds.height)
        self.addSubview(scrollView)
        
        tapView.frame = self.bounds
        self.addSubview(tapView)
    }
    
    private func modifyDatasource() {
        guard var tempInput = datasource, tempInput.count >= 2 else {
            _datasource = datasource
            return
        }

        let firstLast = (tempInput.first!, tempInput.last!)
        tempInput.append(firstLast.0)
        tempInput.insert(firstLast.1, at: 0)

        print("_datasource set to: \(tempInput)")

        self._datasource = tempInput
    }
    
    private func setupContentView() {

        let subviews = scrollView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }

        guard let data = _datasource else { return }

        self.scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(data.count),
                                             height: scrollView.frame.size.height)

        for i in 0..<data.count {
            var frame = CGRect()
            frame.origin.x = scrollView.frame.size.width * CGFloat(i)
            frame.origin.y = 0
            frame.size = scrollView.frame.size

            let label = UILabel(frame: frame)
            label.text = data[i]
            self.scrollView.addSubview(label)
        }
        let index = 1
        scrollView.contentOffset = CGPoint(x: (scrollView.frame.width * CGFloat(index)), y: 0)
        self.selectedOption = data[index]
    }
    

    

    @objc
    func didReceiveTap(sender: UITapGestureRecognizer) {
        guard let data = datasource else { return }

        var index = Int(scrollView.contentOffset.x / scrollView.frame.width)
        index = index < data.count ? index : 0
        self.selectedOption = data[index]

        let x = scrollView.contentOffset.x
        let nextRect = CGRect(x: x + scrollView.frame.width,
                              y: 0,
                              width: scrollView.frame.width,
                              height: scrollView.frame.height)

        scrollView.scrollRectToVisible(nextRect, animated: true)
    }
}

extension InfiniteScrollView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        guard _datasource != nil else { return }

        let x = scrollView.contentOffset.x
        if x >=  scrollView.frame.size.width * CGFloat(_datasource!.count - 1) {
            self.scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width , y: 0)
        } else if x < scrollView.frame.width {
            self.scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width * CGFloat(_datasource!.count - 2), y: 0)
        }
    }
}
