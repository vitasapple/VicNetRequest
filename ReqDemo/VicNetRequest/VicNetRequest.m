//
//  VicNetRequest.m
//  ReqDemo
//
//  Created by 金牛 on 2018/3/15.
//  Copyright © 2018年 vicnic. All rights reserved.
//

#import "VicNetRequest.h"
#import "AFNetworking.h"

@implementation VicNetRequest
+(instancetype)shareManager{
    VicNetRequest * w = [[VicNetRequest alloc]init];
    return w;
}
-(NetModel*)vic_model{
    NetModel * model = [[NetModel alloc]init];
    return model;
}
@end

@interface NetModel()
@property(nonatomic,copy)NSString * urlStr;
@property(nonatomic,copy)NSDictionary * paraDic;
@property(nonatomic,assign)BOOL isShowHud;
@property(nonatomic,assign)BOOL isCache;
@property(nonatomic,assign)HTTPMethod method;
@property(nonatomic,assign)NSInteger cacheInput;
@property(nonatomic,copy)NSString * fileNameStr;
@property(nonatomic,retain)NSData * fileData;
@property(nonatomic,copy)NSString * serveNameStr;
@property(nonatomic,copy)NSString * mimeTypeStr;
@property(nonatomic,copy)NSString * downDirStr;
@property(nonatomic,retain)NSProgress * progress;
@end

@implementation NetModel
@synthesize urlBlock = _urlBlock;
@synthesize paraBlock = _paraBlock;
@synthesize methodBlock = _methodBlock;
@synthesize showHudBlock = _showHudBlock;
@synthesize cacheBlock = _cacheBlock;
@synthesize fileNameBlock = _fileNameBlock;
@synthesize fileBlock = _fileBlock;
@synthesize serveNameBlock = _serveNameBlock;
@synthesize mimeTypeBlock = _mimeTypeBlock;
@synthesize downDirBlock = _downDirBlock;
@synthesize progressBlock = _progressBlock;
@synthesize addBlock = _addBlock;

-(VicAddOtherBlock)addBlock{
    if (!_addBlock) {
        _addBlock = [self dealWithAddBlock];
    }
    return _addBlock;
}
-(VicNetUrlBlock)urlBlock{
    if (!_urlBlock) {
        _urlBlock = [self dealWithUrl];
    }
    return _urlBlock;
}
-(VicNetParaDicBlock)paraBlock{
    if (!_paraBlock) {
        _paraBlock = [self dealWithParaDic];
    }
    return _paraBlock;
}
-(VicNetMethod)methodBlock{
    if (!_methodBlock) {
        _methodBlock = [self dealWithMethod];
    }
    return _methodBlock;
}
-(VicNetHud)showHudBlock{
    if (!_showHudBlock) {
        _showHudBlock = [self dealWithHud];
    }
    return _showHudBlock;
}
-(VicNetCacheBlock)cacheBlock{
    if (!_cacheBlock) {
        _cacheBlock = [self dealWithCache];
        _cacheInput = 666;
    }
    return _cacheBlock;
}
-(VicNetUploadFileName)fileNameBlock{
    if (!_fileNameBlock) {
        _fileNameBlock = [self dealWithFileName];
    }
    return _fileNameBlock;
}
-(VicNetUploadFile)fileBlock{
    if (!_fileBlock) {
        _fileBlock = [self dealWithFile];
    }
    return _fileBlock;
}
-(VicServeName)serveNameBlock{
    if (!_serveNameBlock) {
        _serveNameBlock = [self dealWithServiceName];
    }
    return _serveNameBlock;
}
-(VicMimeType)mimeTypeBlock{
    if (!_mimeTypeBlock) {
        _mimeTypeBlock = [self dealWithMimeType];
    }
    return _mimeTypeBlock;
}
-(VicDownFileDir)downDirBlock{
    if (!_downDirBlock) {
        _downDirBlock = [self dealWithDownLoadDir];
    }
    return _downDirBlock;
}
-(VicDownFileProgress)progressBlock{
    if (!_progressBlock) {
        _progressBlock = [self dealWithProgress];
    }
    return _progressBlock;
}


-(VicAddOtherBlock)dealWithAddBlock{
    __weak typeof(self) weakSelf = self;
    return ^(){
        //在这里写入你需要的额外代码，该block默认为空参数，可自行根据需要添加
        NSLog(@"执行了额外代码");
        return weakSelf;
    };
}
-(VicNetParaDicBlock)dealWithParaDic{
    __weak typeof(self) weakSelf = self;
    return ^(NSDictionary * dic){
        self.paraDic = dic;
        return weakSelf;
    };
}
-(VicNetUrlBlock)dealWithUrl{
    __weak typeof(self) weakSelf = self;
    return ^(NSString * url){
        self.urlStr = url;
        return weakSelf;
    };
}
-(VicNetMethod)dealWithMethod{
    __weak typeof(self) weakSelf = self;
    return ^(HTTPMethod method){
        self.method = method;
        return weakSelf;
    };
}
-(VicNetHud)dealWithHud{
    __weak typeof(self) weakSelf = self;
    return ^(BOOL isShowHud){
        self.isShowHud = isShowHud;
        return weakSelf;
    };
}
-(VicNetCacheBlock)dealWithCache{
    __weak typeof(self) weakSelf = self;
    return ^(BOOL isCache){
        self.isCache = isCache;
        return weakSelf;
    };
}
-(VicNetUploadFileName)dealWithFileName{
    __weak typeof(self) weakSelf = self;
    return ^(NSString * fileName){
        self.fileNameStr = fileName;
        return weakSelf;
    };
}
-(VicNetUploadFile)dealWithFile{
    __weak typeof(self) weakSelf = self;
    return ^(NSData * fileData){
        self.fileData = fileData;
        return weakSelf;
    };
}
-(VicServeName)dealWithServiceName{
    __weak typeof (self) weakSelf = self;
    return ^(NSString * serviceName){
        self.serveNameStr = serviceName;
        return weakSelf;
    };
}
-(VicMimeType)dealWithMimeType{
    __weak typeof (self) weakSelf = self;
    return ^(NSString * mimeType){
        self.mimeTypeStr = mimeType;
        return weakSelf;
    };
}
-(VicDownFileDir)dealWithDownLoadDir{
    __weak typeof (self) weakSelf = self;
    return ^(NSString * downDirStr){
        self.downDirStr = downDirStr;
        return weakSelf;
    };
}
-(VicDownFileProgress)dealWithProgress{
    __weak typeof (self) weakSelf = self;
    return ^(NSProgress * progress){
        self.progress = progress;
        return weakSelf;
    };
}

#pragma mark 请求实现代码
-(void)startRequestWithCache:(CacheDicBlock)cacheBackBlock Success:(SuccessBlock)successBlock Fail:(FailBlock)failBlock{
    NSAssert(self.method != 0, @"请求方法不能为空");
    NSAssert(self.urlStr.length >0, @"请求url不能为空");
    NSAssert(self.cacheInput ==666, @"缓存不能为空");
    if (self.isShowHud==YES) {
        [self showYourHud];
    }
    NSString *cacheKey = _urlStr;
    if (_paraDic && _isCache==YES) {
        cacheKey = [_urlStr stringByAppendingString:[self convertJsonStringFromDictionaryOrArray:_paraDic]];
    }
    if (cacheBackBlock) {
        cacheBackBlock([VicNetCache getResponseCacheForKey:cacheKey]);
    }
    [self requesByAFNWithCacheKey:cacheKey success:successBlock Fail:failBlock];
}
-(void)startRequestWithSuccess:(SuccessBlock)successBlock Fail:(FailBlock)failBlock{
    NSAssert(self.method != 0, @"请求方法不能为空");
    NSAssert(self.urlStr.length >0, @"请求url不能为空");
    _isCache = NO;//防止用户调用此无缓存的方法又使用了缓存block
    if (self.isShowHud==YES) {
        [self showYourHud];
    }
    [self requesByAFNWithCacheKey:nil success:successBlock Fail:failBlock];
}
-(void)startRequestStringByPostWithSuccess:(SuccessBlock)successBlock Fail:(FailBlock)failBlock{
    NSAssert(self.method == 2, @"请求方法必须为post");
    NSAssert(self.urlStr.length >0, @"请求url不能为空");
    if (_isShowHud==YES) {
        [self showYourHud];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:_paraDic options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self dismissYourHud];
        if (!error) {
            NSDictionary *dict = [self objToDic:data];
            successBlock(dict);
        }else{
            failBlock(error);
        }
    }];
    [dataTask resume];
}
-(void)requesByAFNWithCacheKey:(NSString*)cacheKey success:(SuccessBlock)successBlock Fail:(FailBlock)failBlock{
    AFHTTPSessionManager *manager = [self returnManager];
    if (_urlStr.length>0) {
        switch (self.method) {
            case GET:{
                [manager GET:_urlStr parameters:_paraDic progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (_isShowHud==YES) {
                        [self dismissYourHud];
                    }
                    NSDictionary * dict = [self objToDic:responseObject];
                    if (_isCache == YES) {
                        [VicNetCache saveResponseCache:dict forKey:cacheKey];
                    }
                    if (self.addInNetBlock) {
                        /**默认空返回有需要添加相应的参数即可
                         */
                        self.addInNetBlock();
                    }
                    successBlock(dict);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (_isShowHud==YES) {
                        [self dismissYourHud];
                    }
                    failBlock(error);
                }];
            }break;
            case POST:{
                [manager POST:_urlStr parameters:_paraDic progress:^(NSProgress * _Nonnull uploadProgress) {
                    // 获取到目前的数据请求的进度
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (_isShowHud==YES) {
                        [self dismissYourHud];
                    }
                    NSDictionary * dict = [self objToDic:responseObject];
                    if (_isCache == YES) {
                        [VicNetCache saveResponseCache:dict forKey:cacheKey];
                    }
                    if (self.addInNetBlock) {
                        /**默认空返回有需要添加相应的参数即可
                         */
                        self.addInNetBlock();
                    }
                    successBlock(dict);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (_isShowHud==YES) {
                        [self dismissYourHud];
                    }
                    failBlock(error);
                }];
            }break;
            case PUT:{
                [manager PUT:_urlStr parameters:_paraDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (_isShowHud==YES) {
                        [self dismissYourHud];
                    }
                    NSDictionary * dict = [self objToDic:responseObject];
                    if (_isCache == YES) {
                        [VicNetCache saveResponseCache:dict forKey:cacheKey];
                    }
                    if (self.addInNetBlock) {
                        /**默认空返回有需要添加相应的参数即可
                         */
                        self.addInNetBlock();
                    }
                    successBlock(dict);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (_isShowHud==YES) {
                        [self dismissYourHud];
                    }
                    failBlock(error);
                }];
            }break;
            case DELETE:{
                [manager DELETE:_urlStr parameters:_paraDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (_isShowHud==YES) {
                        [self dismissYourHud];
                    }
                    NSDictionary * dict = [self objToDic:responseObject];
                    if (_isCache == YES) {
                        [VicNetCache saveResponseCache:dict forKey:cacheKey];
                    }
                    if (self.addInNetBlock) {
                        /**默认空返回有需要添加相应的参数即可
                         */
                        self.addInNetBlock();
                    }
                    successBlock(dict);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (_isShowHud==YES) {
                        [self dismissYourHud];
                    }
                    failBlock(error);
                }];
            }break;
            default:
                break;
        }
    }
}
-(void)startUploadWithSuccess:(SuccessBlock)successBlock Fail:(FailBlock)failBlock{
    NSAssert(self.method == 2, @"请求方法必须为post");
    NSAssert(self.urlStr.length >0, @"请求url不能为空");
    AFHTTPSessionManager *manager = [self returnManager];
    if (_isShowHud == YES) {
        [self showYourHud];
    }
    
    [manager POST:_urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:_fileData name:_serveNameStr fileName:_fileNameStr mimeType:_mimeTypeStr];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        _progressBlock ? _progressBlock(uploadProgress) : nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (_isShowHud == YES) {
            [self dismissYourHud];
        }
        NSDictionary *dict = [self objToDic:responseObject];
        successBlock(dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (_isShowHud == YES) {
            [self dismissYourHud];
        }
        failBlock ? failBlock(error) : nil;
    }];
}
-(NSURLSessionTask *)startDownLoadWithSuccess:(void(^)(NSString *filePath))successBlock Fail:(FailBlock)failBlock{
    AFHTTPSessionManager *manager = [self returnManager];
    if (_isShowHud == YES) {
        [self showYourHud];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        _progressBlock ? _progressBlock(downloadProgress) : nil;
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (_isShowHud == YES) {
            [self dismissYourHud];
        }
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:_downDirStr ? _downDirStr : @"VicNetworkHelper"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (_isShowHud == YES) {
            [self dismissYourHud];
        }
        successBlock ? successBlock(filePath.absoluteString /** NSURL->NSString*/) : nil;
        failBlock && error ? failBlock(error) : nil;
    }];
    [downloadTask resume];
    return downloadTask;
}
#pragma mark 网络监控
+(void)AFNetMonitorNet:(NetStateBlock)netBlock{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr startMonitoring];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        netBlock(status);//0,-1表示无网络
    }];
}
#pragma mark AFHTTPSessionManager创建
-(AFHTTPSessionManager *)returnManager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60;
    manager.requestSerializer.cachePolicy = NSURLCacheStorageNotAllowed;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"multipart/form-data", nil];
    return manager;
}
#pragma mark 你的HUD代码
-(void)showYourHud{
    
}
-(void)dismissYourHud{
    
}
#pragma mark 工具代码
-(NSString *)convertJsonStringFromDictionaryOrArray:(id)parameter {
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}
-(NSDictionary *)objToDic:(id)obj{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
    return dict;
}
#pragma mark 清理缓存
+(void)cleanCacheAll{
    [VicNetCache removeAllResponseCache];
}
@end
