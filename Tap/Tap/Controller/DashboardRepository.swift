
import Foundation

struct DashboardRepository {
    func performUserInfoWith(userInfo: UserInfo, successHandler: @escaping(UserInfo) -> Void, errorHandler: @escaping(Error) -> Void) {
        NetworkManager.makeRequest(TapHttpRouter.getUserInfo(walletId: userInfo.walletId ?? "0"),showProgress: true)
            .onSuccess { (response: UserInfo) in
                successHandler(response)
            }
            .onFailure { error in
                errorHandler(error)
                print(error.localizedDescription)
            }.onComplete { _ in
        }
    }
    
    func performUserCreditWalletWith(creditWallet: CreditWallet, successHandler: @escaping(CreditWallet) -> Void, errorHandler: @escaping(Error) -> Void) {
        let customerId = creditWallet.receiptID
        
        NetworkManager.makeRequest(TapHttpRouter.postCreditWallet(walletId: creditWallet.walletId ?? "0", currency: creditWallet.currency ?? "KWD", amount: creditWallet.amount ?? "0", source: creditWallet.source ?? [:]),showProgress: true)
            .onSuccess { (response: CreditWallet) in
                response.receiptID = customerId
                successHandler(response)
            }
            .onFailure { error in
                errorHandler(error)
                print(error.localizedDescription)
            }.onComplete { _ in
        }
    }
    
    
    func performUserDebitWalletWith(debitsWallet: DebitsWallet, successHandler: @escaping(DebitsWallet) -> Void, errorHandler: @escaping(Error) -> Void) {
        let customerId = debitsWallet.receiptID
        
        NetworkManager.makeRequest(TapHttpRouter.postDebitWallet(walletId: debitsWallet.walletId ?? "0", currency: debitsWallet.currency ?? "KWD", amount: debitsWallet.amount ?? "0", source: debitsWallet.source ?? [:],destinationId: debitsWallet.destinationId ?? "0"),showProgress: true)
            .onSuccess { (response: DebitsWallet) in
                response.receiptID = customerId
                successHandler(response)
            }
            .onFailure { error in
                errorHandler(error)
                print(error.localizedDescription)
            }.onComplete { _ in
        }
    }
}
