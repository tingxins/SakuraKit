//
//  TXSakuraTableView.m
//  SakuraKit
//
//  Created by tingxins on 28/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraTableView.h"

@implementation TXSakuraTableView

#pragma mark - UIView

- (TXSakuraTableViewBlock)backgroundColor {
    return (TXSakuraTableViewBlock)[super backgroundColor];
}

- (TXSakuraTableViewBlock)alpha {
    return (TXSakuraTableViewBlock)[super alpha];
}

- (TXSakuraTableViewBlock)tintColor {
    return (TXSakuraTableViewBlock)[super tintColor];
}

#pragma mark - UITableView

- (TXSakuraTableViewBlock)separatorColor {
    return (TXSakuraTableViewBlock)[super tx_sakuraColorBlockWithName:NSStringFromSelector(_cmd)];
}

@end

TXSakuraCategoryImplementation(UITableView, TXSakuraTableView)

