//
//  TXSakuraBar.h
//  SakuraKit
//
//  Created by tingxins on 27/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakura.h"

TXSakuraBlockDeclare(TXSakuraBar)

@interface TXSakuraBar : TXSakura
// UIView
- (TXSakuraBarBlock)backgroundColor;

// UITabBar
/** Unselected items in this tab bar will be tinted with this color. Setting this value to nil indicates that UITabBar should use its default value instead. */
- (TXSakuraBarBlock)unselectedItemTintColor NS_AVAILABLE_IOS(10_0);

// UIToolBar
- (TXSakuraBarBlock)barStyle;
- (TXSakuraBarBlock)tintColor;
- (TXSakuraBarBlock)barTintColor;
- (TXSakuraBarBlock)backgroundImage;

// UISearchBar
- (TXSakuraBarBlock)keyboardAppearance;
@end

TXSakuraCategoryDeclare(UITabBar, TXSakuraBar)
TXSakuraCategoryDeclare(UIToolbar, TXSakuraBar)
TXSakuraCategoryDeclare(UISearchBar, TXSakuraBar)
