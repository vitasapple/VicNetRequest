# VicNetRequest
**VicNetRequest是一套以链式语法的对AFNetworking的封装框架，改框架有三个优点**
* 容错性高。链式语法本身就具有高度的容错性，出来必要的参数在debug的时候会通过断言提示，其他参数都可传可不传，都不影响代码的运行。
以上方法若是换成api集中式的话就会出现牵一发动全身的情况，当你要添加一个Version属性做API版本判断的时候，你能怎么办？只能重写方法，然后所有使用的网络请求都要改变方法。（代码来源网上）
```
- (void)GET:(NSString *)url
        parameters:(id)Parameters
        success:(SuccessBlock)success
        failure:(FailureBlock)failure;
```

本来我只想要发一条最普通的get请求，结果写了这么一大长串是不是很郁闷
```
[VicNetTools requestWithGetUrl:PBBTokenVerify_URL parameter:@{@"token":token,@"device_id":@(1)} showLoadingView:YES caches:NO cacheResponse:nil success:^(NSDictionary *backDic) {
       
    } fail:^(NSError *error) {
        
    }];
```
但是如果用链式语法的话………就像这样
```
[VicNetRequest shareManager].vic_model.methodBlock(GET).urlBlock(@"http://api.hykpay.com/api/sys/GetApp?apptype=1").showHudBlock(YES).cacheBlock(NO)
[VicNetRequest shareManager].vic_model.methodBlock(POST).urlBlock(@"http://api.jinniushuju.com/api/sys/BJTime")
```
* 该框架默认关闭系统自带缓存，使用了更为安全优秀的使用MD5加密的第三方缓存框架[PINCache](https://github.com/pinterest/PINCache),嗯，很安全

* 最后一点，也是设计该框架的初衷，是为了对付产品和后台，当你相安无事乐呵呵地度过了每一个轻松的日子，产品突然跑过来说，我们要在每个接口都打印一下版本号！！！(╯‵□′)╯︵┻━┻你为什么不早说，现在都进入迭代了你来告诉我要打印什么版本号？？？那我岂不是要把所有接口都改一遍？或者发个通知给父类ViewController？可是我好像不是所有的ViewController都继承自父类ViewController，产品你过来，把保证不用键盘砸你
当你辛辛苦苦一个一个接口都复制黏贴好了之后后台跑来说，哎呀我忘记处理了某些东西了，现在你要在收到某个字符串之后让把用户踢下线！！！！(╯‵□′)╯︵┻━┻这活还能不能干了！！！！
痛定思痛，必须要有一个能随时更改，高度容错的框架，嗯，响应式是一个很好的选择，于是VicNetRequest诞生了，从来不造轮子的我终于拿起了自己的锄头o(*￣︶￣*)o


## 用法
日志：2018-03-15 1.0尚未接入HUD，后续会补上，但是在代码内已经写好了，你只需要在if内写入你的HUD代码即可，具体如下(以SVProgressHUD为例)
```
//开始发送请求前
if (isShowLoding==YES) {
        [SVProgressHUD show];
    }
    
//收到后台返回数据后
if (isShowLoding==YES) {
    [SVProgressHUD dismiss];
}
```

```
//get缓存请求有菊花但不进行缓存（但实现了缓存block）
    [[VicNetRequest shareManager].vic_model.methodBlock(GET).urlBlock(@"http://api.hykpay.com/api/sys/GetApp?apptype=1").showHudBlock(YES).cacheBlock(NO) startRequestWithCache:^(NSDictionary *cacheDic) {

    } Success:^(NSDictionary *successDic) {

    } Fail:^(NSError *error) {

    }];
```
```
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
