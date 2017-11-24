//
//  SecondViewController.m
//  SakuraDemo_OC
//
//  Created by tingxins on 04/07/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "SecondViewController.h"
#import "TXSakuraKit.h"

@interface SecondViewController ()<TXSakuraDownloadDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configsTheme];
}

- (void)configsTheme {
    self.sakura
    .title(@"Second.title");
    
    self.bgImageView.sakura
    .image(@"Second.backgroundImage");
    
    self.slider.sakura.thumbImage(@"Second.tabImage",UIControlStateNormal);
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen mainScreen].bounds.size.height;
}

@end
