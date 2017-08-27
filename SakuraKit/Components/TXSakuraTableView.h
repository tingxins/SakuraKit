//
//  TXSakuraTableView.h
//  SakuraKit
//
//  Created by tingxins on 28/06/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "TXSakuraView.h"

TXSakuraBlockDeclare(TXSakuraTableView)

@interface TXSakuraTableView : TXSakuraView

// UIView
- (TXSakuraTableViewBlock)backgroundColor;
- (TXSakuraTableViewBlock)alpha;
- (TXSakuraTableViewBlock)tintColor;

// UITableView
- (TXSakuraTableViewBlock)separatorColor;

@end

TXSakuraCategoryDeclare(UITableView, TXSakuraTableView)
