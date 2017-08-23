//
//  TXSakuraBar.m
//  SakuraKit
//
//  Created by tingxins on 27/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraBar.h"

@implementation TXSakuraBar

#pragma mark - UIView

- (TXSakuraBarBlock)backgroundColor {
    return (TXSakuraBarBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

#pragma mark - UITabBar

- (TXSakuraBarBlock)unselectedItemTintColor {
    return (TXSakuraBarBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

#pragma mark - UIToolBar

- (TXSakuraBarBlock)barStyle {
    return (TXSakuraBarBlock)[super tx_sakuraBarStyleBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraBarBlock)backgroundImage {
    return (TXSakuraBarBlock)[super tx_sakuraImageBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraBarBlock)tintColor {
    return (TXSakuraBarBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraBarBlock)barTintColor {
    return (TXSakuraBarBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

#pragma mark - UISearchBar

- (TXSakuraBarBlock)keyboardAppearance {
    return (TXSakuraBarBlock)[super tx_sakuraKeyboardAppearanceBlockWithName:NSStringFromSelector(_cmd)];
}

@end

TXSakuraCategoryImplementation(UITabBar, TXSakuraBar)
TXSakuraCategoryImplementation(UIToolbar, TXSakuraBar)
TXSakuraCategoryImplementation(UISearchBar, TXSakuraBar)
