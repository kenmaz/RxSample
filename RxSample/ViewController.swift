//
//  ViewController.swift
//  RxSample
//
//  Created by Kentaro Matsumae on 2018/03/23.
//  Copyright © 2018年 kenmaz.net. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var fowardButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prevButton.rx.tap.asObservable().subscribe(onNext: { [weak self] () in
            self?.viewModel.prevButtonDidTap()
        }).disposed(by: disposeBag)
        
        fowardButton.rx.tap.asObservable().subscribe(onNext: { [weak self] () in
            self?.viewModel.forwardButtonDidTap()
        }).disposed(by: disposeBag)
        
        addButton.rx.tap.asObservable().subscribe(onNext: {[weak self] () in
            self?.viewModel.addButtonDidTap()
        }).disposed(by: disposeBag)
        
        viewModel.label.asObservable().subscribe(onNext: {[weak self] (label) in
            self?.pageLabel.text = label
        }).disposed(by: disposeBag)
    }
    
    class ViewModel {
        struct Page {
            let idx: Int
        }
        var pages: BehaviorRelay<[Page]> = BehaviorRelay(value: [])
        var index: BehaviorRelay<Int> = BehaviorRelay(value: 0)
        var label: BehaviorRelay<String> = BehaviorRelay(value: "")
        
        init() {
            _ = pages.subscribe(onNext: {[weak self] (pages) in
                self?.updateLabel()
            })
            _ = index.subscribe(onNext: {[weak self] (_) in
                self?.updateLabel()
            })
            addPage()
        }
        
        private func updateLabel() {
            self.label.accept("\(index.value + 1)/\(pages.value.count)")
        }
        
        func prevButtonDidTap() {
            if index.value > 0 {
                index.accept(index.value - 1)
            } else {
                index.accept(pages.value.count - 1)
            }
        }
        func forwardButtonDidTap() {
            if index.value < pages.value.count - 1 {
                index.accept(index.value + 1)
            } else {
                index.accept(0)
            }
        }
        func addButtonDidTap() {
            addPage()
        }
        private func addPage() {
            var list = pages.value
            let idx = list.count + 1
            let page = Page(idx: idx)
            list.append(page)
            pages.accept(list)
        }
        
    }
}

