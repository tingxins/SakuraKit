//
//  TXSakuraTrash.m
//  SakuraKit
//
//  Created by tingxins on 28/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#define TXSakuraTrashReturn return [self trashBlock];

#import "TXSakuraTrash.h"

@implementation TXSakuraTrash

- (TXSakuraTrashBlock)trashBlock {
    return ^(id obj) { };
}

- (TXSakuraTrashBlock)barTintColor {
    TXSakuraTrashReturn
}

- (TXSakuraTrashBlock)tintColor {
    TXSakuraTrashReturn
}

- (TXSakuraTrashBlock)titleTextAttributes {
    TXSakuraTrashReturn
}

@end
