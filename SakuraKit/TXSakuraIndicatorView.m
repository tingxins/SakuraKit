//
//  TXSakuraIndicatorView.m
//  SakuraKit
//
//  Created by tingxins on 29/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraIndicatorView.h"

@implementation TXSakuraIndicatorView

- (TXSakuraIndicatorViewBlock)color {
    return (TXSakuraIndicatorViewBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}


- (TXSakuraIndicatorViewBlock)activityIndicatorViewStyle {
    return (TXSakuraIndicatorViewBlock)[super tx_sakuraIndicatorViewStyleBlockWithName:NSStringFromSelector(_cmd)];
}

@end

TXSakuraCategoryImplementation(UIActivityIndicatorView, TXSakuraIndicatorView)
