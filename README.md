# VicNetRequest
**VicNetRequest是一套以链式语法的对AFNetworking的封装框架，改框架有三个有点**
* 容错性高。链式语法本身就具有高度的容错性，出来必要的参数在debug的时候会通过断言提示，其他参数都可传可不传，都不影响代码的运行。示例如下
```
[VicNetRequest shareManager].vic_model.methodBlock(GET).urlBlock(@"http://api.hykpay.com/api/sys/GetApp?apptype=1").showHudBlock(YES).cacheBlock(NO)
[VicNetRequest shareManager].vic_model.methodBlock(POST).urlBlock(@"http://api.jinniushuju.com/api/sys/BJTime")
```
以上方法若是换成api集中式的话就会出现牵一发动全身的情况，当你要添加一个Version属性做API版本判断的时候，你能怎么办？只能重写方法，然后所有使用的网络请求都要改变方法。（代码来源网上）
```
- (void)GET:(NSString *)url
        parameters:(id)Parameters
        success:(SuccessBlock)success
        failure:(FailureBlock)failure;
```
* 该框架使用了优秀的第三方缓存框架[PINCache](https://github.com/pinterest/PINCache),嗯，很安全
* 本来是有第三点的，但是我给忘了……………………

## 用法
```
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
```
```
    //若产品增加需求，且该需求不需要根据后台返回做处理，只需要实现事先准备好的addBlock，或者你自己实现也可以
    [[VicNetRequest shareManager].vic_model.urlBlock(@"http://api.hykpay.com/api/sys/GetApp?apptype=1").methodBlock(GET).addBlock().cacheBlock(YES) startRequestWithCache:^(NSDictionary *cacheDic) {

    } Success:^(NSDictionary *successDic) {
        NSLog(@"%@",successDic);
    } Fail:^(NSError *error) {

    }];
 ```
 ```
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
   ```
