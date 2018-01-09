//
//  SYHTTPSessionManager.h
//  SYErrorManager
//
//  Created by 吕俊 on 2018/1/8.
//  Copyright © 2018年 sandboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SYConfig.h"

@interface SYHTTPSessionManager : NSObject

/**
 *  POST 网络请求
 *
 *  @param URL       URL
 *  @param parameter 参数
 *  @param returnBlock   成功
 *  @param errorBlock      失败
 *  @param failureBlock      网络错误
 */
+ (void)requestPostNetWithURL:(NSString*)URL
                 andParameter:(NSDictionary*)parameter
         withReturnValueBlock:(ReturnValueBlock)returnBlock
           withErrorCodeBlock:(ErrorCodeBlock)errorBlock
             withFailureBlock:(FailureValueBlock)failureBlock;



/**
 *  文件上传或表单上传
 *
 *  @param urlStr  URL
 *  @param parameters 参数
 *  @param fileURL  文件路径
 *  @param returnBlock   成功
 *  @param errorBlock      失败
 *  @param failureBlock      网络错误
 */
+ (void)postUploadWithUrl:(NSString *)urlStr
             andParameter:(NSDictionary*)parameters
                  fileUrl:(NSURL *)fileURL
     withReturnValueBlock:(ReturnValueBlock)returnBlock
       withErrorCodeBlock:(ErrorCodeBlock)errorBlock
         withFailureBlock:(FailureValueBlock)failureBlock;

/**
 *  文件下载
 *
 *  @param urlStr  文件地址
 *  @param savePath 保存路径
 *  @param returnBlock   成功
 *  @param errorBlock      失败
 *  @param failureBlock      网络错误
 */
+ (void)sessionDownloadWithUrl:(NSString *)urlStr
                    saveAtPath:(NSString*)savePath
          withReturnValueBlock:(ReturnValueBlock)returnBlock
            withErrorCodeBlock:(ErrorCodeBlock)errorBlock
              withFailureBlock:(FailureValueBlock)failureBlock;




/**
 *  POST 上传文件数据 和json数据
 *
 *  @param urlStr    URLString
 *  @param parameter 参数
 *  @param imageArray      图片路径数组
 *  @param returnBlock   成功
 *  @param errorBlock      失败
 *  @param failureBlock      网络错误
 */
+ (void)postUploadFileDataAndJsonWithUrl:(NSString*)urlStr
                            andParameter:(NSDictionary*)parameter
                           andImageArray:(NSArray *)imageArray
                    withReturnValueBlock:(ReturnValueBlock)returnBlock
                      withErrorCodeBlock:(ErrorCodeBlock)errorBlock
                        withFailureBlock:(FailureValueBlock)failureBlock;


#pragma mark - 带有 超时时长的 POST 请求
/**
 *  POST 网络请求
 *  @param parameter  参数
 *  @param interval    超时时间
 *  @param returnBlock   成功
 *  @param errorBlock      失败
 *  @param failureBlock      网络错误
 */
+ (void)netWithTimeOutPostNetWithURL:(NSString*)URL
                        andParameter:(NSDictionary*)parameter
                     timeoutInterval:(CGFloat)interval
                withReturnValueBlock:(ReturnValueBlock)returnBlock
                  withErrorCodeBlock:(ErrorCodeBlock)errorBlock
                    withFailureBlock:(FailureValueBlock)failureBlock;
@end
