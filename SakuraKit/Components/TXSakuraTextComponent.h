//
//  TXSakuraTextComponent.h
//  SakuraKit
//
//  Created by tingxins on 28/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraView.h"

TXSakuraBlockDeclare(TXSakuraTextComponent)

@interface TXSakuraTextComponent : TXSakuraView

// UIView
- (TXSakuraTextComponentBlock)backgroundColor;
- (TXSakuraTextComponentBlock)alpha;
- (TXSakuraTextComponentBlock)tintColor;

// UITextField + UITextView
- (TXSakuraTextComponentBlock)font;
- (TXSakuraTextComponentBlock)keyboardAppearance;
- (TXSakuraTextComponentBlock)textColor;

@end

TXSakuraCategoryDeclare(UITextField, TXSakuraTextComponent)
TXSakuraCategoryDeclare(UITextView, TXSakuraTextComponent)
