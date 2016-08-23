//
//  SelectPaymentViewController.swift
//  RxDealCell
//
//  Created by DianQK on 8/5/16.
//  Copyright © 2016 T. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct SelectPayment: Hashable, Equatable, IdentifiableType {
    let select: Variable<Payment>

    var hashValue: Int {
        return select.value.hashValue
    }

    var identity: Int {
        return select.value.hashValue
    }

    init(defaultSelected: Payment) {
        select = Variable(defaultSelected)
    }
}

func ==(lhs: SelectPayment, rhs: SelectPayment) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

typealias PaymentSectionModel = AnimatableSectionModel<SelectPayment, Payment>

class SelectPaymentViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private let dataSource = RxTableViewSectionedReloadDataSource<PaymentSectionModel>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        dataSource.configureCell = { ds, tb, ip, payment in
            let cell = tb.dequeueReusableCell(withIdentifier: R.reuseIdentifier.paymentTableViewCell, for: ip)!
            cell.setPayment(payment)
            let selectedPayment = ds.sectionAtIndex(ip.section).model.select.asObservable()
            selectedPayment
                .map { $0 == payment }
                .bindTo(cell.rx_isSelectedPayment)
                .addDisposableTo(cell.reusableDisposeBag)
            return cell
        }
        
        let selectPayment = SelectPayment(defaultSelected: Payment.alipay)
        
        tableView
            .rx.modelSelected(Payment.self)
            .bindTo(selectPayment.select)
            .addDisposableTo(disposeBag)
        
        let paymentSection = PaymentSectionModel(
            model: selectPayment, items: [
            Payment.alipay,
            Payment.wechat,
            Payment.unionpay
            ])
        
        Observable.just([paymentSection])
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        tableView.rx.itemSelected
            .map { ($0, animated: true) }
            .subscribe(onNext: tableView.deselectRow)
            .addDisposableTo(disposeBag)
    }

}
