//
//  TXSakuraController.h
//  SakuraDemo_OC
//
//  Created by tingxins on 01/08/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakura.h"

TXSakuraBlockDeclare(TXSakuraController)

@interface TXSakuraController : TXSakura

- (TXSakuraControllerBlock)title;

@end

TXSakuraCategoryDeclare(UIViewController, TXSakuraController)
