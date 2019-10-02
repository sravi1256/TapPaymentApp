//
//  ButtonsTableViewHandlerDelegate.swift
//  TapAlertViewController
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	CoreGraphics.CGGeometry.CGSize
import protocol	TapAdditionsKit.ClassProtocol

internal protocol ButtonsTableViewHandlerDelegate: ClassProtocol {
	
	func buttonsTableViewHandler(_ buttonsTableViewHandler: ButtonsTableViewHandler, tableViewContentSizeChangedTo size: CGSize)
}
