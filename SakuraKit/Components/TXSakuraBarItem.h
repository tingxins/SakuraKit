//
//  TXSakuraBarItem.h
//  SakuraKit
//
//  Created by tingxins on 28/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakura.h"

TXSakuraBlockDeclare(TXSakuraBarItem)
TXSakura2DStateBlockDeclare(TXSakuraBarItem)

@interface TXSakuraBarItem : TXSakura
// UITabBarItem

- (TXSakuraBarItem2DStateBlock)titleTextAttributes;
- (TXSakuraBarItemBlock)selectedImage;

// UIBarItem
- (TXSakuraBarItemBlock)image;
- (TXSakuraBarItemBlock)title;

@end

TXSakuraCategoryDeclare(UIBarItem, TXSakuraBarItem)
