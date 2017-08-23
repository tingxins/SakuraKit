//
//  FourthViewController.m
//  SakuraDemo_OC
//
//  Created by tingxins on 04/07/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//

#import "FourthViewController.h"
#import "TXSakuraKit.h"

@interface FourthViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *atNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UISwitch *switchView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@end

@implementation FourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configsTheme];
}

- (void)configsTheme {
    self.sakura
    .title(@"Fourth.title");
    
    self.avatarImageView.sakura
    .image(@"Fourth.tabImage");
//    .highlightedImage(@"Second.tabImage");
//    .highlighted(@"Fourth.highlighted");
    
    self.bgImageView.sakura
    .image(@"Fourth.backgroundImage");
    
    self.editButton.sakura
    .backgroundColor(@"Fourth.editProfileBackgroundColor");
    
    self.userNameLabel.sakura
    .textColor(@"Fourth.userNameColor");
    
    self.atNameLabel.sakura
    .textColor(@"Fourth.atNameColor");
    
    self.logoutButton.sakura
    .backgroundColor(@"Fourth.logoutBackgroundColor")
    .titleColor(@"Fourth.logoutTitleColor", UIControlStateNormal);
    
    self.view.sakura
    .backgroundColor(@"Global.backgroundColor");
    
    self.shareButton.sakura
    .image(@"Fourth.shareImage", UIControlStateNormal)
    .image(@"Fourth.shareImageH", UIControlStateHighlighted);
    
    self.welcomeLabel.sakura
    .textColor(@"Fourth.welcomeTextColor");
    
    self.switchView.sakura
    .onTintColor(@"Fourth.switchOnColor")
    .thumbTintColor(@"Fourth.switchOffColor");
}

- (IBAction)valueChange:(UISwitch *)sender {
    
}

- (IBAction)cleanCache:(UIBarButtonItem *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tips:" message:@"This Operation will remove all sakuras." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionClear = [UIAlertAction actionWithTitle:@"Clear" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // Clean all.
        [TXSakuraManager tx_clearSakuraAllCaches];
        // Clean your sakura with NAME!
//        [TXSakuraManager tx_clearSakuraCacheWithName:@"weibo"];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:actionClear];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)editProfile:(UIButton *)sender {
    
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen mainScreen].bounds.size.height;
}

@end
