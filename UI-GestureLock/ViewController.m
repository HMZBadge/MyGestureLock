//
//  ViewController.m
//  UI-GestureLock
//
//  Created by 赵志丹 on 15/10/28.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "ViewController.h"
#import "ZDGestureView.h"
#import "ZDMainViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet ZDGestureView *gettureView;
@property (weak, nonatomic) IBOutlet UIImageView *myView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_refresh_bg"]];
    NSString *pwd = @"13457";
    
    __weak ViewController *weakSelf = self; //这样就可以解决了循环引用的问题了.ZDMainViewController
    self.gettureView.passwordBlock = ^(NSString *password,UIImage *image){
        weakSelf.myView.image = image;// 会有循环引用的问题
        if ([pwd isEqualToString:password]) {
            //手势正确 进行跳转
            ZDMainViewController *mainVc = [[ZDMainViewController alloc] init];
            [weakSelf presentViewController:mainVc animated:YES completion:nil];
            
            return YES;
        }else{
            NSLog(@"手势错误");
            return NO;
        }
    };
}
@end
