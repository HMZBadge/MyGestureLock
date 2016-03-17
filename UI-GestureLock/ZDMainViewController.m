//
//  ZDMainViewController.m
//  UI-GestureLock
//
//  Created by 赵志丹 on 15/10/30.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "ZDMainViewController.h"

@interface ZDMainViewController ()

@end

@implementation ZDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"main"];
    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    myImageView.image = image;
    
    //[myImageView setContentMode:UIViewContentModeCenter];
    [self.view addSubview:myImageView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
