//
//  TXSakuraController.m
//  SakuraDemo_OC
//
//  Created by tingxins on 01/08/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraController.h"

@implementation TXSakuraController

- (TXSakuraControllerBlock)title {
    return (TXSakuraControllerBlock)[super tx_sakuraTitleBlockWithName:NSStringFromSelector(_cmd)];
}

@end

TXSakuraCategoryImplementation(UIViewController, TXSakuraController)
