//
//  TXSakuraTextComponent.m
//  SakuraKit
//
//  Created by tingxins on 28/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraTextComponent.h"

@implementation TXSakuraTextComponent

#pragma mark - UIView

- (TXSakuraTextComponentBlock)backgroundColor {
    return (TXSakuraTextComponentBlock)[super backgroundColor];
}

- (TXSakuraTextComponentBlock)alpha {
    return (TXSakuraTextComponentBlock)[super alpha];
}

- (TXSakuraTextComponentBlock)tintColor {
    return (TXSakuraTextComponentBlock)[super tintColor];
}

#pragma mark - UITextField + UITextView

- (TXSakuraTextComponentBlock)font {
    return (TXSakuraTextComponentBlock)[super tx_sakuraFontBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraTextComponentBlock)keyboardAppearance {
    return (TXSakuraTextComponentBlock)[super tx_sakuraKeyboardAppearanceBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraTextComponentBlock)textColor {
    return (TXSakuraTextComponentBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

@end

TXSakuraCategoryImplementation(UITextField, TXSakuraTextComponent)
TXSakuraCategoryImplementation(UITextView, TXSakuraTextComponent)
