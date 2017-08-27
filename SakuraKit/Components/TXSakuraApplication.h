//
//  TXSakuraApplication.h
//  SakuraKit
//
//  Created by tingxins on 27/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakura.h"
@class TXSakuraApplication;

TXSakura2DBoolBlockDeclare(TXSakuraApplication);

@interface TXSakuraApplication : TXSakura

- (TXSakuraApplication2DBoolBlock)statusBarStyle;

@end

TXSakuraCategoryDeclare(UIApplication, TXSakuraApplication)

