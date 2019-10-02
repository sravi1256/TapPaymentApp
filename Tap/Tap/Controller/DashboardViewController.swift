
import UIKit
import goSellSDK

class DashboardViewController: BaseViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tranferButton: UIButton!
    @IBOutlet weak var topUpButton: UIButton!
    @IBOutlet weak var tapDiscriptionLabel: UILabel!
    @IBOutlet weak var transationLabel: UILabel!
    @IBOutlet weak var walletBalanceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var payButton: PayButton?
    internal var selectedPaymentItem: PaymentItem?
    
    lazy var presenter = DashboardPresenter(repository: DashboardRepository(), delegate: self)
    var customerIDs :String = ""
    var receiptList : [[String: Any]] = []
    
    var paymentItems: [PaymentItem] = Serializer.deserialize()
    var selectedPaymentItems: [PaymentItem]?
   
    var currentCustomers: EnvironmentCustomer = DashboardViewController.createEmptyCustomer() {
        didSet {}
    }
    static func createEmptyCustomer() -> EnvironmentCustomer {
        let customer = try! Customer(identifier: "new")
        customer.identifier = nil
        let envCustomer = EnvironmentCustomer(customer: customer, environment: .sandbox)
        return envCustomer
    }
    var itemd: [PaymentItem]? {
        
        let oneUnit = Quantity(value: 1, unitOfMeasurement: .units)
        let firstItem = PaymentItem(title: "Test",quantity: oneUnit,amountPerUnit: 0)
        
        let oneHundredSquareMeters = Quantity(value:100,unitOfMeasurement:.area(.squareMeters))
        let tenPercents = AmountModificator(percents: 0)
        let thousandMoney = AmountModificator(fixedAmount: 0)
        let thousandKD = Tax(title: "KD 100.000",descriptionText:"",amount: thousandMoney)
        
        let secondItem = PaymentItem(title:"#2",descriptionText: "Test.",quantity:oneHundredSquareMeters,amountPerUnit:1,discount:tenPercents,taxes:[thousandKD])
        
        return [firstItem, secondItem]
    }
    
    var newCustomer: Customer? {
        
        let emailAddress = try! EmailAddress(emailAddressString: "s.khaled@myreddress.com")
        let phoneNumber = try! PhoneNumber(isdNumber: "965", phoneNumber: "55555555")
        return try? Customer(emailAddress: emailAddress, phoneNumber: phoneNumber,firstName:"Sarah",middleName:nil, lastName:"Khaled")
    }
    // MARK: Methods
    
    var paymentSettings: Settings = Serializer.deserialize() ?? .default {
        didSet {
            GoSellSDK.language = self.paymentSettings.global.sdkLanguage.localeIdentifier
            GoSellSDK.mode = self.paymentSettings.dataSource.sdkMode
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.additonalSetup()
    }
    
    private func additonalSetup() {
        self.ignoresKeyboardEventsWhenWindowIsNotKey = true
        GoSellSDK.language = self.paymentSettings.global.sdkLanguage.localeIdentifier
        GoSellSDK.mode = self.paymentSettings.dataSource.sdkMode
        self.currentCustomers.customer = newCustomer!
        self.paymentSettings.dataSource.customer =  self.currentCustomers
        Serializer.serialize(self.currentCustomers)
        Serializer.serialize(self.paymentSettings)
        self.selectedPaymentItems = itemd
        self.paymentItems = itemd ?? []
        self.updatePayButtonAmount()
        topUpButton.layer.cornerRadius = 5.0
        tranferButton.layer.cornerRadius = 5.0
        transationLabel.isHidden = true
        tranferButton.isHidden = true
        tapDiscriptionLabel.isHidden = false
        payButton?.isHidden = true
        topUpButton.isHidden = false
        presenter.getUserInfo(walletId: "1")
    }
    
    func updatePayButtonAmount() {
        self.payButton?.updateDisplayedState()
    }
    
    
    @IBAction func topUpClicked(_ sender: Any) {
        updatePayButtonAmount()
        showAlert(title: "Wallet to up", message: "Add 100.000 KWD to your wallet!", actionTitles: ["Ok"], actions:[{action1 in
            self.payButton?.isHidden = false
            self.topUpButton.isHidden = true
            }, nil])
    }
    
    @IBAction func transferClicked(_ sender: Any) {
        
        var source :[String : Any] = [:]
        source["id"] = customerIDs
        let debitsWallet = DebitsWallet()
        debitsWallet.walletId = "1"
        debitsWallet.currency = "KWD"
        debitsWallet.amount = "100.000"
        debitsWallet.source = source
        debitsWallet.destinationId = "1"
        presenter.debitWallet(debitsWallet: debitsWallet)
    }
}



extension DashboardViewController : DashboardDelegate {
    
    func finishPerformingUserDebitWalletWithSuccess(debitsWallet: DebitsWallet) {
        let balance = debitsWallet.balance ?? 0
        walletBalanceLabel.text = "\(String(balance)) \(debitsWallet.currency ?? "")"
        showAlert(title: "10 KWD Transfered!", message: "You just sent mariam some money! She will love you forever!", actionTitles: ["Ok"], actions:[{action1 in
            
            }, nil])
        }
    
    func finishPerformingUserDebitWalletWithError(error: String) {
        showAlert(title: "Error", message: error, actionTitles: ["Ok"], actions:[{action1 in
            
            }, nil])
    }
    
    func finishPerformingUserInfoWithSuccess(userInfo: UserInfo) {
        nameLabel.text = userInfo.customer?.name?.first
        let balance = userInfo.balance ?? 0
        walletBalanceLabel.text = "\(String(balance)) \(userInfo.currency ?? "")"
    }
    
    func finishPerformingUserInfoWithError(error: String) {
        showAlert(title: "Error", message: error, actionTitles: ["Ok"], actions:[{action1 in
            }, nil])
    }
    
    func finishPerformingUserCreditWalletWithSuccess(creditWallet: CreditWallet) {
        receiptList.append(["id":creditWallet.receiptID ?? "0"])
        let balance = creditWallet.balance ?? 0
        walletBalanceLabel.text = "\(String(balance)) \(creditWallet.currency ?? "")"
        if receiptList.count > 0 {
            transationLabel.isHidden = false
            tranferButton.isHidden = false
            tapDiscriptionLabel.isHidden = true
        }
        tableView.reloadData()
    }
    
    func finishPerformingUserCreditWalletWithError(error: String) {
        showAlert(title: "Error", message: error, actionTitles: ["Ok"], actions:[{action1 in
            
            }, nil])
    }
}


extension DashboardViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receiptList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransationHistoryCell", for: indexPath) as! TransationHistoryCell
        
        cell.setup( recipet: receiptList[indexPath.row]["id"] as! String)
        
        return cell
    }
}

// MARK: - SessionDataSource
extension DashboardViewController: SessionDataSource {
    
     var currency: Currency? {
        
        return self.paymentSettings.dataSource.currency
    }
    
     var customer: Customer? {
        
        return self.paymentSettings.dataSource.customer?.customer
    }
   
     var items: [PaymentItem]? {
        
        return self.selectedPaymentItems
    }
    
     var destinations: [Destination]? {
        
        return self.paymentSettings.dataSource.destinations
    }
    
     var mode: TransactionMode {
        
        return self.paymentSettings.dataSource.transactionMode
    }
    
     var taxes: [Tax]? {
        
        return self.paymentSettings.dataSource.taxes
    }
    
     var shipping: [Shipping]? {
        
        return self.paymentSettings.dataSource.shippingList
    }
    
     var require3DSecure: Bool {
        
        return self.paymentSettings.dataSource.isThreeDSecure
    }
    
     var allowsToSaveSameCardMoreThanOnce: Bool {
        
        return self.paymentSettings.dataSource.canSaveSameCardMultipleTimes
    }
    
     var isSaveCardSwitchOnByDefault: Bool {
        
        return self.paymentSettings.dataSource.isSaveCardSwitchToggleEnabledByDefault
    }
    
     var receiptSettings: Receipt? {
        
        return Receipt(email: true, sms: true)
    }
    
     var authorizeAction: AuthorizeAction {
        
        return .capture(after: 8)
    }
}


// MARK: - SessionDelegate
extension DashboardViewController: SessionDelegate {
    
     func paymentSucceed(_ charge: Charge, on session: SessionProtocol) {
        
        // payment succeed, saving the customer for reuse.
        showAlert(title: "Wallet Topped Up!", message: "You've added 100.000 KWD to your wallet successfully!", actionTitles: ["Back"], actions:[{action1 in
            self.payButton?.isHidden = true
            self.topUpButton.isHidden = false
            }, nil])
        if let customerID = charge.customer.identifier {
            customerIDs = customerID
            var source :[String : Any] = [:]
            source["id"] = customerID
            let creditWallet = CreditWallet()
            creditWallet.receiptID = charge.receiptSettings?.identifier
            creditWallet.walletId = "1"
            creditWallet.currency = "KWD"
            creditWallet.amount = "100.000"
            creditWallet.source = source
            presenter.creditWallet(creditWallet: creditWallet)
            self.saveCustomer(customerID)
        }
    }
    
     func authorizationSucceed(_ authorize: Authorize, on session: SessionProtocol) {
        
        // authorization succeed, saving the customer for reuse.
        
        if let customerID = authorize.customer.identifier {
            self.saveCustomer(customerID)
        }
    }
    
     func paymentFailed(with charge: Charge?, error: TapSDKError?, on session: SessionProtocol) {
        
        // payment failed, payment screen closed.
    }
    
     func authorizationFailed(with authorize: Authorize?, error: TapSDKError?, on session: SessionProtocol) {
        
        // authorization failed, payment screen closed.
    }
    
     func sessionCancelled(_ session: SessionProtocol) {
        self.payButton?.isHidden = true
        self.topUpButton.isHidden = false
        // payment cancelled (user manually closed the payment screen).
    }
    
     func cardSaved(_ cardVerification: CardVerification, on session: SessionProtocol) {
        
        // card successfully saved.
        if let customerID = cardVerification.customer.identifier {
            self.saveCustomer(customerID)
          }
    }
    
     func cardSavingFailed(with cardVerification: CardVerification?, error: TapSDKError?, on session: SessionProtocol) {
        
        // card failed to save.
    }
    
     func cardTokenized(_ token: Token, on session: SessionProtocol, customerRequestedToSaveTheCard saveCard: Bool) {
        
        // card has successfully tokenized.
    }
    
     func cardTokenizationFailed(with error: TapSDKError, on session: SessionProtocol) {
        
        // card failed to tokenize
    }
    
     func sessionIsStarting(_ session: SessionProtocol) {
        
        // session is about to start, but UI is not yet shown.
    }
    
     func sessionHasStarted(_ session: SessionProtocol) {
        
        // session has started, UI is shown (or showing)
    }
    
     func sessionHasFailedToStart(_ session: SessionProtocol) {
        
        // session has failed to start.
    }
    
     func saveCustomer(_ customerID: String) {
        
        if let nonnullCustomer = self.customer {
            
            let envCustomer = SerializationHelper.updateCustomer(nonnullCustomer, with: customerID)
            
            self.paymentSettings.dataSource.customer = envCustomer
            Serializer.serialize(self.paymentSettings)
        }
    }
}

