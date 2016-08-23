//
//  SelectTableViewCell.swift
//  RxDealCell
//
//  Created by 宋宋 on 8/8/16.
//  Copyright © 2016 T. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectTableViewCell: RXTableViewCell {
    
    var rx_isSelected: ControlProperty<Bool> {
        let source = Observable<Bool>.create { [weak self] (observer) in
            self?._isSelectedChanged = observer.onNext
            return Disposables.create()
            }
        
        let sink = selectButton.rx.selected
        
        return ControlProperty(values: source, valueSink: sink)
    }
    
    private var _isSelectedChanged: ((Bool) -> Void)?
    
    var name: String? {
        get {
            return nameLabel?.text
        }
        set {
            nameLabel.text = newValue
        }
    }

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var selectButton: UIButton! {
        didSet {
            selectButton.addTarget(self, action: #selector(SelectTableViewCell.selectButtonTap), for: .touchUpInside)
        }
    }
    
    
    private dynamic func selectButtonTap() {
        selectButton.isSelected = !selectButton.isSelected
        _isSelectedChanged?(selectButton.isSelected)
    }
    

}
