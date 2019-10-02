
import Foundation

class DashboardPresenter {
    
    private var repository: DashboardRepository?
    private weak var delegate: DashboardDelegate?
    
    init(repository: DashboardRepository, delegate: DashboardDelegate) {
        self.repository = repository
        self.delegate = delegate
    }
    
   func getUserInfo(walletId: String) {
        let userInfo = UserInfo()
        userInfo.walletId = walletId
        repository?.performUserInfoWith(userInfo: userInfo, successHandler: { (userInfo) in
           self.delegate?.finishPerformingUserInfoWithSuccess(userInfo: userInfo)
            
        }) { (error) in
            self.delegate?.finishPerformingUserInfoWithError(error: error.localizedDescription)
        }
    }
    
    func creditWallet(creditWallet: CreditWallet) {
        
        repository?.performUserCreditWalletWith(creditWallet: creditWallet, successHandler: { (creditWallet) in
            self.delegate?.finishPerformingUserCreditWalletWithSuccess(creditWallet: creditWallet)
            
        }) { (error) in
            self.delegate?.finishPerformingUserCreditWalletWithError(error: error.localizedDescription)
        }
    }
    
    
    func debitWallet(debitsWallet: DebitsWallet) {
        
        repository?.performUserDebitWalletWith(debitsWallet: debitsWallet, successHandler: { (debitsWallet) in
            self.delegate?.finishPerformingUserDebitWalletWithSuccess(debitsWallet: debitsWallet)
            
        }) { (error) in
            self.delegate?.finishPerformingUserDebitWalletWithError(error: error.localizedDescription)
        }
    }
}
