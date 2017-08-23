//
//  PopViewController.m
//  SakuraDemo_OC
//
//  Created by tingxins on 05/07/2017.
//  Copyright © 2017 tingxins. All rights reserved.
//  

#import "PopViewController.h"
#import "TXSakuraKit.h"

@interface PopViewController ()<TXSakuraDownloadDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *popImageView;

@end

@implementation PopViewController

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popImageView.sakura
    .image(@"Second.tabSelectImage");

}
- (IBAction)dismiss:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
