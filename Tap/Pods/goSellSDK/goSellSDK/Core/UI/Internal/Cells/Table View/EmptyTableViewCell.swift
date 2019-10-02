//
//  EmptyTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGBase.CGFloat
import class UIKit.UITableViewCell.UITableViewCell

internal class EmptyTableViewCell: BaseTableViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: EmptyTableViewCellModel?
}

// MARK: - LoadingWithModelCell
extension EmptyTableViewCell: LoadingWithModelCell {
    
    internal func updateContent(animated: Bool) { }
}
