//
//  TXSakuraLabel.h
//  SakuraKit
//
//  Created by tingxins on 23/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraView.h"

TXSakuraBlockDeclare(TXSakuraLabel)

@interface TXSakuraLabel : TXSakuraView
// UIView
- (TXSakuraLabelBlock)backgroundColor;
- (TXSakuraLabelBlock)alpha;
- (TXSakuraLabelBlock)tintColor;
// UILabel
- (TXSakuraLabelBlock)highlighted;
- (TXSakuraLabelBlock)highlightedTextColor;
- (TXSakuraLabelBlock)shadowColor;
- (TXSakuraLabelBlock)textColor;
- (TXSakuraLabelBlock)font;
@end

TXSakuraCategoryDeclare(UILabel, TXSakuraLabel)
