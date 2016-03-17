//
//  ZDGestureView.h
//  UI-GestureLock
//
//  Created by 赵志丹 on 15/10/28.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDGestureView : UIView
@property (nonatomic,copy) BOOL (^passwordBlock)(NSString *,UIImage *);
@end
