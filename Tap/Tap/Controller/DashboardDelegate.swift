
import Foundation

protocol DashboardDelegate: class {
    func finishPerformingUserInfoWithSuccess(userInfo: UserInfo)
    func finishPerformingUserInfoWithError(error: String)
    
    func finishPerformingUserCreditWalletWithSuccess(creditWallet: CreditWallet)
    func finishPerformingUserCreditWalletWithError(error: String)
    
    func finishPerformingUserDebitWalletWithSuccess(debitsWallet: DebitsWallet)
    func finishPerformingUserDebitWalletWithError(error: String)
}
