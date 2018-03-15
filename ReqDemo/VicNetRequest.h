//
//  VicNetRequest.h
//  ReqDemo
//
//  Created by 金牛 on 2018/3/15.
//  Copyright © 2018年 vicnic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VicNetCache.h"
@class NetModel;
typedef enum {
    GET=1,
    POST,
    PUT,
    DELETE,
} HTTPMethod;

typedef void (^NetStateBlock)(NSInteger netState);
//预备的block，用户额外的需求添加，该block默认为空参数，可自行根据需要添加
typedef NetModel * (^VicAddOtherBlock)(void);
//预备的block，用户额外的需求添加，不同于上方的block在于改block是接收到后台返回后进行的处理操作
typedef void (^VicAddInNetBlock)(void);

typedef NetModel * (^VicNetUrlBlock)(NSString * url);
typedef NetModel * (^VicNetParaDicBlock)(NSDictionary *dic);
typedef NetModel * (^VicNetMethod)(HTTPMethod method);
typedef NetModel * (^VicNetHud)(BOOL isShowHud);
typedef NetModel * (^VicNetCacheBlock)(BOOL isCache);
/***********************************************************/
//上传下载block
//文件名
typedef NetModel * (^VicNetUploadFileName)(NSString * fileName);
//文件
typedef NetModel * (^VicNetUploadFile)(NSData * file);
//服务器要存储的文件名给的字段
typedef NetModel * (^VicServeName)(NSString * serveName);
//类似@"image/png"这种
typedef NetModel * (^VicMimeType)(NSString * mimeType);
//文件存储目录(默认存储目录为Download)
typedef NetModel * (^VicDownFileDir)(NSString * fileDir);
//文件下载的进度信息
typedef NetModel * (^VicDownFileProgress)(NSProgress * progress);
/***********************************************************/
typedef void (^SuccessBlock)(NSDictionary * successDic);
typedef void (^CacheDicBlock)(NSDictionary * cacheDic);
typedef void (^FailBlock)(NSError * error);


@interface VicNetRequest : NSObject
+(instancetype)shareManager;
-(NetModel*)vic_model;
@end

@interface NetModel : NSObject

//常规网络参数
@property(nonatomic,copy,readonly) VicNetUrlBlock urlBlock;
@property(nonatomic,copy,readonly) VicNetParaDicBlock paraBlock;
@property(nonatomic,copy,readonly) VicNetMethod methodBlock;
@property(nonatomic,copy,readonly) VicNetHud showHudBlock;
@property(nonatomic,copy,readonly) VicNetCacheBlock cacheBlock;
//上传下载网络参数
@property(nonatomic,copy,readonly) VicNetUploadFileName fileNameBlock;
@property(nonatomic,copy,readonly) VicNetUploadFile fileBlock;
@property(nonatomic,copy,readonly) VicServeName serveNameBlock;
@property(nonatomic,copy,readonly) VicMimeType mimeTypeBlock;
@property(nonatomic,copy,readonly) VicDownFileDir downDirBlock;
@property(nonatomic,copy,readonly) VicDownFileProgress progressBlock;
//预备的block，用户额外的需求添加
@property(nonatomic,copy,readonly) VicAddOtherBlock addBlock;
@property(nonatomic,copy) VicAddInNetBlock addInNetBlock;
/**
 默认有缓存
 */
-(void)startRequestWithCache:(CacheDicBlock)cacheBackBlock Success:(SuccessBlock)successBlock Fail:(FailBlock)failBlock;
/**
 默认无缓存
 */
-(void)startRequestWithSuccess:(SuccessBlock)successBlock Fail:(FailBlock)failBlock;
/**
 post方法发json字符串给后台
 用户某些后台需要将dict全部转为字符串发送，常规的post会发送失败，反正我是还没搞清楚为什么，目前遇到的是.net后台,post就不用缓存了
 */
-(void)startRequestStringByPostWithSuccess:(SuccessBlock)successBlock Fail:(FailBlock)failBlock;
/**
 上传
 */
-(void)startUploadWithSuccess:(SuccessBlock)successBlock Fail:(FailBlock)failBlock;
/**
 下载
 */
-(NSURLSessionTask *)startDownLoadWithSuccess:(void(^)(NSString *filePath))successBlock Fail:(FailBlock)failBlock;

//网络监测  netState<1无网络连接
+(void)AFNetMonitorNet:(NetStateBlock)netBlock;
+(void)cleanCacheAll;
@end
