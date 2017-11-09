//
//  PerformPaymentViewController.swift
//  SeniorProject
//
//  Created by Tunscopi on 11/8/17.
//  Copyright © 2017 blah. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class PerformPaymentViewController: UIViewController, STPPaymentContextDelegate {
  
  let stripePublishableKey = "pk_test_02eNXzxoQjDt8eaaQi8a11tP"
  
  // To save user's payment details
  let backendBaseURL: String? = "https://chariotstripe.herokuapp.com"
  
  let paymentCurrency = "USD"
  let paymentContext: STPPaymentContext
  let theme: STPTheme
  let paymentRow: CheckoutRowView
  let donationRow: CheckoutRowView
  let confirmButton: ConfirmButton
  let rowHeight: CGFloat = 44
  let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  let numberFormatter: NumberFormatter
  var organization = ""
  var orgDisp = UILabel()
  
  var paymentInProgress: Bool = false {
    didSet{
      UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
        if self.paymentInProgress {
          self.activityIndicator.startAnimating()
          self.activityIndicator.alpha = 1
          self.confirmButton.alpha = 0
        } else {
          self.activityIndicator.stopAnimating()
          self.activityIndicator.alpha = 0
          self.confirmButton.alpha = 1
        }
      }, completion: nil)
    }
  }
  
  init(donationAmount: Int, org:String, settings: Settings) {
    let stripePublishableKey = self.stripePublishableKey
    let backendBaseURL = self.backendBaseURL
    
    assert(stripePublishableKey.hasPrefix("pk_"), "stripe publishable key must be set at the top of this file to run app")
    assert(backendBaseURL != nil, "backendBaseURL must be set at the top of this file to run app")
    
    self.organization = org
    self.orgDisp.text = org
    self.theme = settings.theme
    
    MyAPIClient.sharedClient.baseURLString = self.backendBaseURL
    
    
    // Included here for the sake of readability, should set up your configuration and theme earlier, preferably in AppDelegate.
    let config = STPPaymentConfiguration.shared()
    config.publishableKey = self.stripePublishableKey
    
    let customerContext = STPCustomerContext(keyProvider: MyAPIClient.sharedClient)
    let paymentContext = STPPaymentContext(customerContext: customerContext,
                                           configuration: config,
                                           theme: settings.theme)
    let userInformation = STPUserInformation()
    paymentContext.prefilledInformation = userInformation
    paymentContext.paymentAmount = donationAmount
    paymentContext.paymentCurrency = self.paymentCurrency
    
    self.paymentContext = paymentContext
    
    self.paymentRow = CheckoutRowView(title: "Payment", detail: "Select Payment",
                                      theme: settings.theme)
    self.donationRow = CheckoutRowView(title: "Donation", detail: "", tappable: false,
                                       theme: settings.theme)
    self.confirmButton = ConfirmButton(enabled: true, theme: settings.theme)
    
    var localeComponents: [String: String] = [
      NSLocale.Key.currencyCode.rawValue: self.paymentCurrency,
      ]
    localeComponents[NSLocale.Key.languageCode.rawValue] = NSLocale.preferredLanguages.first
    let localeID = NSLocale.localeIdentifier(fromComponents: localeComponents)
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = Locale(identifier: localeID)
    numberFormatter.numberStyle = .currency
    numberFormatter.usesGroupingSeparator = true
    self.numberFormatter = numberFormatter
    
    super.init(nibName: nil, bundle: nil)
    
    self.paymentContext.delegate = self
    paymentContext.hostViewController = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let backButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
    navigationItem.leftBarButtonItem = backButton
    
    self.view.backgroundColor = self.theme.primaryBackgroundColor
    var red: CGFloat = 0
    self.theme.primaryBackgroundColor.getRed(&red, green: nil, blue: nil, alpha: nil)
    self.activityIndicator.activityIndicatorViewStyle = red < 0.5 ? .white : .gray
    self.navigationItem.title = "Make a Donation"

    self.view.addSubview(self.donationRow)
    self.view.addSubview(self.paymentRow)
    self.view.addSubview(self.orgDisp)
    self.orgDisp.font = UIFont.systemFont(ofSize: 20)
    self.view.addSubview(self.confirmButton)
    self.view.addSubview(self.activityIndicator)
    self.activityIndicator.alpha = 0
    self.confirmButton.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
    self.donationRow.detail = self.numberFormatter.string(from: NSNumber(value: Float(self.paymentContext.paymentAmount)/100))!
    self.paymentRow.onTap = {
      self.paymentContext.pushPaymentMethodsViewController()
    }
    // If you so wish to add shipping info. eg. for a gift, etc
    //self.view.addSubview(self.shippingRow)
    //self.shippingRow.onTap = { self.paymentContext.pushShippingViewController()}
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let width = self.view.bounds.width
    self.orgDisp.sizeToFit()
    self.orgDisp.center = CGPoint(x: width/2.0,
                                       y: self.navigationController!.navigationBar.frame.height + self.orgDisp.bounds.height/2.0 + rowHeight)
    self.paymentRow.frame = CGRect(x: 0, y: self.navigationController!.navigationBar.frame.height + self.orgDisp.frame.maxY + rowHeight,
                                   width: width, height: rowHeight)
    self.donationRow.frame = CGRect(x: 0, y: self.paymentRow.frame.maxY,
                                 width: width, height: rowHeight)
    // If you so wish to add shipping info. eg. for a gift, etc
    //self.shippingRow.frame = CGRect(x: 0, y: self.paymentRow.frame.maxY,
    //                              width: width, height: rowHeight)
    self.confirmButton.frame = CGRect(x: 0, y: 0, width: 88, height: 44)
    self.confirmButton.center = CGPoint(x: width/2.0, y: self.donationRow.frame.maxY + rowHeight*1.5)
    self.activityIndicator.center = self.confirmButton.center
  }
  
  @objc func didTapConfirm() {
    self.paymentInProgress = true
    self.paymentContext.requestPayment()
  }
  
  func goBack(){
    dismiss(animated: true, completion: nil)
  }
  
  
  // MARK: STPPaymentContextDelegate Implementation
  func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
    MyAPIClient.sharedClient.completeCharge(paymentResult,
                                            amount: self.paymentContext.paymentAmount,
                                            shippingAddress: self.paymentContext.shippingAddress,
                                            shippingMethod: self.paymentContext.selectedShippingMethod,
                                            completion: completion)
  }
  
  func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
    self.paymentInProgress = false
    let title: String
    let message: String
    switch status {
    case .error:
      title = "Error"
      message = error?.localizedDescription ?? ""
    case .success:
      title = "Success"
      message = "Thank you for your gift"
    case .userCancellation:
      return
    }
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(action)
    self.present(alertController, animated: true, completion: nil)
  }
  
  func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
    self.paymentRow.loading = paymentContext.loading
    if let paymentMethod = paymentContext.selectedPaymentMethod {
      self.paymentRow.detail = paymentMethod.label
    }
    else {
      self.paymentRow.detail = "Select Payment"
    }
    self.donationRow.detail = self.numberFormatter.string(from: NSNumber(value: Float(self.paymentContext.paymentAmount)/100))!
  }
  
  func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
    print(error.localizedDescription)
    let alertController = UIAlertController(
      title: "Error",
      message: error.localizedDescription,
      preferredStyle: .alert
    )
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
      // Need to assign to _ because optional binding loses @discardableResult value
      // https://bugs.swift.org/browse/SR-1681
      _ = self.navigationController?.popViewController(animated: true)
    })
    let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
      self.paymentContext.retryLoading()
    })
    alertController.addAction(cancel)
    alertController.addAction(retry)
    self.present(alertController, animated: true, completion: nil)
  }
  
  func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping
    STPShippingMethodsCompletionBlock) {
    let upsGround = PKShippingMethod()
    upsGround.amount = 0
    upsGround.label = "UPS Ground"
    upsGround.detail = "Arrives in 3-5 days"
    upsGround.identifier = "ups_ground"
    let upsWorldwide = PKShippingMethod()
    upsWorldwide.amount = 10.99
    upsWorldwide.label = "UPS Worldwide Express"
    upsWorldwide.detail = "Arrives in 1-3 days"
    upsWorldwide.identifier = "ups_worldwide"
    let fedEx = PKShippingMethod()
    fedEx.amount = 5.99
    fedEx.label = "FedEx"
    fedEx.detail = "Arrives tomorrow"
    fedEx.identifier = "fedex"
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      if address.country == nil || address.country == "US" {
        completion(.valid, nil, [upsGround, fedEx], fedEx)
      }
      else if address.country == "AQ" {
        let error = NSError(domain: "ShippingError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Invalid Shipping Address",
                                                                           NSLocalizedFailureReasonErrorKey: "We can't ship to this country."])
        completion(.invalid, error, nil, nil)
      }
      else {
        fedEx.amount = 20.99
        completion(.valid, nil, [upsWorldwide, fedEx], fedEx)
      }
    }
  }
  
}
