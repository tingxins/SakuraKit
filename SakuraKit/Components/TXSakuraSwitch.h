//
//  TXSakuraSwitch.h
//  SakuraKit
//
//  Created by tingxins on 29/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraView.h"

TXSakuraBlockDeclare(TXSakuraSwitch)

@interface TXSakuraSwitch : TXSakuraView
// UIView
- (TXSakuraSwitchBlock)backgroundColor;
- (TXSakuraSwitchBlock)alpha;
- (TXSakuraSwitchBlock)tintColor;

// UISwitch
- (TXSakuraSwitchBlock)onTintColor;
- (TXSakuraSwitchBlock)thumbTintColor;

@end

TXSakuraCategoryDeclare(UISwitch, TXSakuraSwitch)
