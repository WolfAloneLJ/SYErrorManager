# SYErrorManager 简介
网络错误提示（默认所有含NavigationController的VC都会提示，可设置取消）

##问题
> 网络断开时候需要拆分出来统一处理一些事情：断开提醒，跳转到网络设置页，恢复后刷新界面等。


1. 做一个通用且及时的网络错误提示（在navigationBar下显示，并能跳转到设置网络界面），有网时动画消失
2. 网络状态转好以后，对当前页面进行刷新-需要提供公用的刷新方法（验证是否需要登陆，跳转登陆等操作）
3. 从后台进入前台时，判断网络状态，显示网络错误提示等

##效果
![](777.gif)

##思路

> //网络切换通知
AFNetworkingReachabilityDidChangeNotification

> //活跃状态
UIApplicationDidBecomeActiveNotification

> //网络错误提示（自定义）
SYHTTPSessionManagerTaskDidFailedNotification


`1. 在Appdelegate.m中`

> [SYErrorManager manager];

`2. 在简单封装的get、post、upload、download等方法中，当* NSURLSessionDataTask*任务失败时，发送通知MSHTTPSessionManagerTaskDidFailedNotification`


**取消提示**
> 当前界面不需要设置网络错误提醒时：如网络连接跳转界面，视频界面

` xxxxViewController.m`
>  - (BOOL)willShowErrorTipView {
	return NO;
}




