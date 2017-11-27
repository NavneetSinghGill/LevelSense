//
//  PaymentViewController.swift
//  Level Sense
//
//  Created by Zoeb Sheikh on 11/24/17.
//  Copyright © 2017 Zoeb Sheikh. All rights reserved.
//

import UIKit
import PassKit

class PaymentViewController: LSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK:- Overridden methods
    
    override func cartButtonTapped() {
        let item1 = PKPaymentSummaryItem(label: "Shoes", amount: 2)
        let item2 = PKPaymentSummaryItem(label: "clothes", amount: 3)
        let item3 = PKPaymentSummaryItem(label: "chips", amount: 3)
        let item4 = PKPaymentSummaryItem(label: "bearing", amount: 2)
        let total = PKPaymentSummaryItem(label: "Total", amount: 10)
        
        openApplePayScreen(with: [item1, item2, item3, item4, total])
    }
    
    func openApplePayScreen(with items: [PKPaymentSummaryItem]) {
        let request = PKPaymentRequest()
        request.countryCode = "IN"
        request.currencyCode = "INR"
        
        request.paymentSummaryItems = items
        
        let freeShipping = PKShippingMethod(label: "Free Shipping", amount: 0)
        freeShipping.identifier = "free"
        freeShipping.detail = "Arrive in 1-2 weeks"
        
        request.shippingMethods = [freeShipping]
        
        let supportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
        
        //TODO: set this to apple pay button
        //        applePayButton.hidden = !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedPaymentNetworks)
        
        request.merchantIdentifier = "merchant.com.LevelSense.LS"
        request.supportedNetworks = supportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        
        request.requiredShippingAddressFields = [.postalAddress, .phone]
        
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        applePayController.delegate = self
        self.present(applePayController, animated: true, completion: nil)
    }

}

extension PaymentViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        //TODO: Make api call for letting server know about ordered products
        completion(PKPaymentAuthorizationStatus.success)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
