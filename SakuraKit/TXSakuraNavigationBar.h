//
//  TXSakuraNavigationBar.h
//  SakuraKit
//
//  Created by tingxins on 26/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakura.h"
TXSakuraBlockDeclare(TXSakuraNavigationBar)

@interface TXSakuraNavigationBar : TXSakura
- (TXSakuraNavigationBarBlock)barTintColor;
- (TXSakuraNavigationBarBlock)tintColor;
- (TXSakuraNavigationBarBlock)titleTextAttributes;
@end

TXSakuraCategoryDeclare(UINavigationBar, TXSakuraNavigationBar)

