//
//  TXSakuraNavigationBar.h
//  SakuraKit
//
//  Created by tingxins on 26/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakura.h"
TXSakuraBlockDeclare(TXSakuraNavigationBar)
TXSakura2DBarMetricsBlockDeclare(TXSakuraNavigationBar)
@interface TXSakuraNavigationBar : TXSakura
- (TXSakuraNavigationBarBlock)barTintColor;
- (TXSakuraNavigationBarBlock)tintColor;
- (TXSakuraNavigationBarBlock)titleTextAttributes;
- (TXSakuraNavigationBar2DBarMetricsBlock)backgroundImage;
@end

TXSakuraCategoryDeclare(UINavigationBar, TXSakuraNavigationBar)

