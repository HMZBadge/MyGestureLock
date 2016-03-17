//
//  ZDGestureView.m
//  UI-GestureLock
//
//  Created by 赵志丹 on 15/10/28.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#define kButtonCount 9
#import "ZDGestureView.h"
#import "SVProgressHUD.h"

@interface ZDGestureView ()
@property (nonatomic,strong) NSMutableArray *btns;
@property (nonatomic,strong) NSMutableArray *lineBtns;
@property (nonatomic,assign) CGPoint currentPoint;



@end
@implementation ZDGestureView


#pragma mark - 画线
- (void)drawRect:(CGRect)rect{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [[UIColor whiteColor] set];
    [path setLineWidth:10];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineCapStyle:kCGLineCapRound];
    
    for (int i = 0 ; i < self.lineBtns.count; i++) {
        
        if (i == 0) {
            [path moveToPoint:[self.lineBtns[i] center]];
        }
        else{
            [path addLineToPoint:[self.lineBtns[i] center]];
        }
    }
    if (self.lineBtns.count > 0) {
        [path addLineToPoint:self.currentPoint];
    }
    [path stroke];
}


#pragma mark - 设置触摸事件

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //当点击屏幕的时候,让按钮的状态变为 高亮状态,并且添加到 lineBtns 里面
    UITouch *touch = touches.anyObject;
    CGPoint p =[touch locationInView:self];
    for (int i = 0 ; i < self.btns.count; i++) {
        UIButton *btn = self.btns[i];
        if (CGRectContainsPoint(btn.frame, p)) {
            btn.highlighted = YES;
            if (![self.lineBtns containsObject:btn]) {
                [self.lineBtns addObject:btn];
            }
            break;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:self];
    for (int i = 0 ; i < self.btns.count; i++) {
        UIButton *btn = self.btns[i];
        if (CGRectContainsPoint(btn.frame, p)) {
            btn.highlighted = YES;
            if (![self.lineBtns containsObject:btn]) {
                [self.lineBtns addObject:btn];
            }
            break;
        }
    }
    self.currentPoint = p;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.lineBtns.count ==0) {
        return;
    }
    
    self.currentPoint = [[self.lineBtns lastObject] center];
    [self setNeedsDisplay];
    self.userInteractionEnabled = NO;
    //获取绘图的密码
    NSMutableString *password = [NSMutableString string];
    for (int i = 0 ; i < self.lineBtns.count; i++) {
        [password appendFormat:@"%ld",[self.lineBtns[i] tag]];
    }
    
//    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    //获取整个图层的对象,  //调用他的某个方法,把图层的内容渲染到 image上下文当中
    [self.layer renderInContext:contextRef];
    
   
    
    UIImage *gestureImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if (self.passwordBlock) {
        if (self.passwordBlock(password, gestureImage)){
            [SVProgressHUD showSuccessWithStatus:@"密码正确"];
        }else{
            //如果错误
            [SVProgressHUD showErrorWithStatus:@"密码错误"];
            for (int i = 0 ; i < self.lineBtns.count; i++) {
                UIButton *btn = self.lineBtns[i];
                btn.selected = YES;
                btn.highlighted = NO;
            }
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clearGesture];
    });
}

/**
 *  清理手势
 */
- (void)clearGesture{
    
    for (int i = 0 ; i < self.btns.count; i++) {
        UIButton *btn = self.btns[i];
        btn.highlighted = NO;
        btn.selected = NO;
    }
    self.userInteractionEnabled = YES;
    [self.lineBtns removeAllObjects];
    [self setNeedsDisplay];
}


#pragma mark - 设置九宫格按钮frame
- (void)layoutSubviews{
    CGFloat w = 74;
    CGFloat h = w;
    NSInteger count = 3;
    CGFloat margin = (self.bounds.size.width - w*count)/(count +1);
    for (int i = 0 ; i < self.btns.count; i++) {
        UIButton *btn = self.btns[i];
        int row = i / count;
        int col = i % count;
        CGFloat x = margin + (margin + w) * col;
        CGFloat y = margin + (margin + h) * row;
        btn.frame = CGRectMake(x, y, w, h);
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)btns{
    if (!_btns) {
        _btns = [NSMutableArray array];
        
        for (int i = 0 ; i < kButtonCount; i++) {
            UIButton *btn = [[UIButton alloc] init];
            [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_error"] forState:UIControlStateSelected];
            btn.userInteractionEnabled = NO;
            btn.tag = i;
            [self addSubview:btn];
            [self.btns addObject:btn];
        }
    }
    return _btns;
}

- (NSMutableArray *)lineBtns{
    if (!_lineBtns) {
        _lineBtns = [NSMutableArray array];
    }
    return _lineBtns;
}


@end
