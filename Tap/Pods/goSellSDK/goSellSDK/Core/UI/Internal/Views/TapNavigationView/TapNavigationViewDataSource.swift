//
//  TapNavigationViewDataSource.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol	TapAdditionsKit.ClassProtocol

internal protocol TapNavigationViewDataSource: ClassProtocol {
	
	func navigationViewCanGoBack(_ navigationView: TapNavigationView) -> Bool
	
	func navigationViewIconPlaceholder(for navigationView: TapNavigationView) -> Image?
	
	func navigationViewIcon(for navigationView: TapNavigationView) -> Image?
	
	func navigationViewTitle(for navigationView: TapNavigationView) -> String?
}
