//
//  TXSakuraNavigationBar.m
//  SakuraKit
//
//  Created by tingxins on 26/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraNavigationBar.h"

@implementation TXSakuraNavigationBar

- (TXSakuraNavigationBarBlock)barTintColor {
    return (TXSakuraNavigationBarBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraNavigationBarBlock)tintColor {
    return (TXSakuraNavigationBarBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraNavigationBarBlock)titleTextAttributes {
    return (TXSakuraNavigationBarBlock)[super tx_sakuraTitleTextAttributesBlockWithName:NSStringFromSelector(_cmd)];
}

@end

TXSakuraCategoryImplementation(UINavigationBar, TXSakuraNavigationBar)
