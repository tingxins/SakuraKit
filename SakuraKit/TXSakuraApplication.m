//
//  TXSakuraApplication.m
//  SakuraKit
//
//  Created by tingxins on 27/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraApplication.h"

@implementation TXSakuraApplication

- (TXSakuraApplication2DBoolBlock)statusBarStyle {
    return (TXSakuraApplication2DBoolBlock)[super tx_sakuraApplicationForStyleBlockWithName:NSStringFromSelector(_cmd)];
}

@end

TXSakuraCategoryImplementation(UIApplication, TXSakuraApplication)
