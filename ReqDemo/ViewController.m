//
//  ViewController.m
//  ReqDemo
//
//  Created by 金牛 on 2018/3/14.
//  Copyright © 2018年 vicnic. All rights reserved.
//

#import "ViewController.h"
#import "VicNetRequest.h"
@class NetModel;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //get缓存请求有菊花但不进行缓存（但实现了缓存block）
    [[VicNetRequest shareManager].vic_model.methodBlock(GET).urlBlock(@"http://api.hykpay.com/api/sys/GetApp?apptype=1").showHudBlock(YES).cacheBlock(NO) startRequestWithCache:^(NSDictionary *cacheDic) {

    } Success:^(NSDictionary *successDic) {

    } Fail:^(NSError *error) {

    }];
    //post请求无菊花无缓存
    [[VicNetRequest shareManager].vic_model.methodBlock(POST).urlBlock(@"http://api.jinniushuju.com/api/sys/BJTime") startRequestWithSuccess:^(NSDictionary *successDic) {
        NSLog(@"%@",successDic);
    } Fail:^(NSError *error) {

    }];

    //若产品增加需求，且该需求不需要根据后台返回做处理，只需要实现事先准备好的addBlock，或者你自己实现也可以
    [[VicNetRequest shareManager].vic_model.urlBlock(@"http://api.hykpay.com/api/sys/GetApp?apptype=1").methodBlock(GET).addBlock().cacheBlock(YES) startRequestWithCache:^(NSDictionary *cacheDic) {

    } Success:^(NSDictionary *successDic) {
        NSLog(@"%@",successDic);
    } Fail:^(NSError *error) {

    }];
    
    //若产品增加需求，但该需求需要根据后台返回做处理，只需要实现事先准备好的addInNetBlock，或者你自己实现也可以
    //这里需要注意的是需要实例一下，虽然我们上方的也是实例，但是是伪实例
    //在改文件的interface上方@class NetModel;
    NetModel * m = [VicNetRequest shareManager].vic_model;
    [m.methodBlock(POST).urlBlock(@"http://api.jinniushuju.com/api/sys/BJTime") startRequestWithSuccess:^(NSDictionary *successDic) {
        NSLog(@"%@",successDic);
    } Fail:^(NSError *error) {
        
    }];
    m.addInNetBlock = ^{
        NSLog(@"收到数据后调用到我了");
    };
}

@end
