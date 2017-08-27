//
//  TXSakuraBarItem.m
//  SakuraKit
//
//  Created by tingxins on 28/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraBarItem.h"

@implementation TXSakuraBarItem

#pragma mark - UITabBar

- (TXSakuraBarItem2DStateBlock)titleTextAttributes {
    return (TXSakuraBarItem2DStateBlock)[super tx_sakuraTitleTextAttributesForStateBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraBarItemBlock)selectedImage {
    return (TXSakuraBarItemBlock)[super tx_sakuraImageBlockWithName:NSStringFromSelector(_cmd)];
}

#pragma mark - UIBarItem


- (TXSakuraBarItemBlock)image {
    return (TXSakuraBarItemBlock)[super tx_sakuraImageBlockWithName:NSStringFromSelector(_cmd)];
}

- (TXSakuraBarItemBlock)title {
    return (TXSakuraBarItemBlock)[super tx_sakuraTitleBlockWithName:NSStringFromSelector(_cmd)];
}

@end

TXSakuraCategoryImplementation(UIBarItem, TXSakuraBarItem)
