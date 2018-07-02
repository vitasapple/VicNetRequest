//
//  VicToastView.m
//  ReqDemo
//
//  Created by Jinniu on 2018/7/2.
//  Copyright © 2018年 vicnic. All rights reserved.
//

#import "VicToastView.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation VicToastView

static VicToastView * v;

+(UIView*)showToastWithMsg:(NSString*)msg andSuperView:(UIView*)superView{
    return [self createView:msg andSuperView:superView];
}
+(UIView*)createView:(NSString*)msg andSuperView:(UIView*)superView{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                 NSParagraphStyleAttributeName : paragraphStyle};
    CGRect rect = [msg boundingRectWithSize:CGSizeMake(ScreenWidth-20, ScreenHeight-20) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    if (v==nil) {
        v = [[self alloc] initWithFrame:CGRectMake(ScreenWidth/2.f-rect.size.width/2.f - 5, ScreenHeight/2.f-rect.size.height/2.f - 5, rect.size.width, rect.size.height)];
        v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [superView addSubview:v];
    }
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, rect.size.width, rect.size.height)];
    lab.text = msg;
    lab.textAlignment = NSTextAlignmentLeft;
    lab.font = [UIFont systemFontOfSize:14];
    [v addSubview:lab];
    
    return v;
}
@end
