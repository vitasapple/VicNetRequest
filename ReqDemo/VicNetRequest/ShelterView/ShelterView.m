//
//  ShelterView.m
//  TwoOneEight
//
//  Created by Jinniu on 2018/6/14.
//  Copyright © 2018年 Jinniu. All rights reserved.
//

#import "ShelterView.h"
@interface ShelterView ()<UIGestureRecognizerDelegate>
@end
@implementation ShelterView
static ShelterView * v;
+(UIView*)shareView{
    return [self createView];
}
+(UIView*)createView{
    if (v==nil) {
        v = [[self alloc] initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
        tap.delegate = v;
        [v addGestureRecognizer:tap];
//        [v addTarget:v action:@selector(btnClick:)];
        UIWindow * w = [UIApplication sharedApplication].delegate.window;
        [w addSubview:v];
    }
    return v;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"ShelterView"]) {
        [ShelterView dismiss];
        return YES;
    }else {
        return NO;
    }
}
+(void)btnClick:(UITapGestureRecognizer*)tap{

//    [ShelterView dismiss];
}
+(void)dismiss{
    [v removeFromSuperview];
    v = nil;
}
+(void)isDark:(BOOL)isDark{
    if (isDark) {
        [ShelterView createView].backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    }else{
        [ShelterView createView].backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    }
}
@end
