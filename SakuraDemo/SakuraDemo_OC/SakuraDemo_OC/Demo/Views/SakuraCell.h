//
//  SakuraCell.h
//  SakuraDemo_OC
//
//  Created by tingxins on 31/07/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SakuraModel, SakuraCell;

@protocol SakuraCellDelegate <NSObject>

- (void)sakuraCell:(SakuraCell *)sakuraCell didClickDownload:(SakuraModel *)sakuraModel atIndexPath:(NSIndexPath *)indexPath;

@end

@interface SakuraCell : UITableViewCell

@property (strong, nonatomic) SakuraModel *sakuraModel;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) id<SakuraCellDelegate> delegate;

@end
