//
//  SakuraCell.m
//  SakuraDemo_OC
//
//  Created by tingxins on 31/07/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "SakuraCell.h"
#import "SakuraModel.h"
@interface SakuraCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingConstraint;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;


@end

@implementation SakuraCell

- (IBAction)clickbutton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sakuraCell:didClickDownload:atIndexPath:)]) {
        [self.delegate sakuraCell:self didClickDownload:_sakuraModel atIndexPath:self.indexPath];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.trailingConstraint.constant = [UIScreen mainScreen].bounds.size.width;
}

- (void)setSakuraModel:(SakuraModel *)sakuraModel {
    _sakuraModel = sakuraModel;
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.trailingConstraint.constant = size.width * (1 - _sakuraModel.progress);
    [self.statusButton setTitle:_sakuraModel.statusName forState:UIControlStateNormal];
    self.nameLabel.text = _sakuraModel.name;
    self.progressView.backgroundColor = _sakuraModel.progressColor;
}

@end
