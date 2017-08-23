//
//  TXSakuraProgress.h
//  SakuraKit
//
//  Created by tingxins on 29/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraView.h"

TXSakuraBlockDeclare(TXSakuraProgress)

@interface TXSakuraProgress : TXSakuraView
// UIView
- (TXSakuraProgressBlock)backgroundColor;
- (TXSakuraProgressBlock)alpha;
- (TXSakuraProgressBlock)tintColor;

// UIProgressView
- (TXSakuraProgressBlock)trackTintColor;
- (TXSakuraProgressBlock)progressTintColor;



@end

TXSakuraCategoryDeclare(UIProgressView, TXSakuraProgress)

