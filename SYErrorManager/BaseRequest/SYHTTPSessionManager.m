//
//  SYHTTPSessionManager.m
//  SYErrorManager
//
//  Created by 吕俊 on 2018/1/8.
//  Copyright © 2018年 sandboy. All rights reserved.
//

#import "SYHTTPSessionManager.h"
#import <AFNetworking.h>
#import "SYErrorManager.h"
static AFHTTPSessionManager *manager;

@implementation SYHTTPSessionManager
#pragma mark - POST 请求
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
             withFailureBlock:(FailureValueBlock)failureBlock{
    if (!manager) {
        manager = [AFHTTPSessionManager manager];
    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",nil];
    // 设置请求格式
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *transString = [NSString stringWithString:[URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    [manager POST:transString parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            returnBlock(responseObject);
        }else{
            errorBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
            [[NSNotificationCenter defaultCenter] postNotificationName:SYHTTPSessionManagerTaskDidFailedNotification object:task];
            failureBlock(error);
        
        
    }];
}


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
                    withFailureBlock:(FailureValueBlock)failureBlock{
    if (!manager) {
        manager = [AFHTTPSessionManager manager];
    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",nil];
    // 设置请求格式
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = interval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSString *transString = [NSString stringWithString:[URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    
    
    [manager POST:transString parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            returnBlock(responseObject);
        }else{
            errorBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [[NSNotificationCenter defaultCenter] postNotificationName:SYHTTPSessionManagerTaskDidFailedNotification object:task];
        if (error) {
            failureBlock(error);
        }
        
    }];
}



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
                        withFailureBlock:(FailureValueBlock)failureBlock{
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //多张图片上传
     /*
      if(imageArray.count)
      {
      for(int i = 0 ;i <imageArray.count; i ++)
      {
      NSString *path = [CustomCalss searchImageFilePathByImageName:imageArray[i] withFolder:nil];
      NSFileManager *file = [NSFileManager defaultManager];
      
      if ([file fileExistsAtPath:path]) {
      [formData appendPartWithFileData:[NSData dataWithContentsOfFile:path] name:@"files" fileName:imageArray[i] mimeType:@"image/png"];
      }
      }
      }
      */
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          
                          UIProgressView *progressView = [[UIProgressView alloc] init];
                          [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                          errorBlock(error);
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          
                          returnBlock(responseObject);
                      }
                  }];
    
    [uploadTask resume];
    
    
    
}


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
         withFailureBlock:(FailureValueBlock)failureBlock
{
    NSString *transString = [NSString stringWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    if (!manager) {
        manager = [AFHTTPSessionManager manager];
    }
    // AFHTTPResponseSerializer就是正常的HTTP请求响应结果:NSData
    // 当请求的返回数据不是JSON,XML,PList,UIImage之外,使用AFHTTPResponseSerializer
    // 实际上就是AFN没有对响应数据做任何处理的情况
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    
    [manager POST:transString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileURL:fileURL name:@"file" fileName:@"fileImage.jpg" mimeType:@"image/jpeg" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            returnBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [[NSNotificationCenter defaultCenter] postNotificationName:SYHTTPSessionManagerTaskDidFailedNotification object:task];
        if (error) {
            errorBlock(error);
        }
    }];
    // formData是遵守了AFMultipartFormData的对象
    //    [manager POST:transString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    //
    //        [formData appendPartWithFileURL:fileURL name:@"uploadFile" error:NULL];
    //    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        if (success) {
    //            success(responseObject);
    //        }
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        KBLog(@"错误 %@", error.localizedDescription);
    //        if (fail) {
    //            fail();
    //        }
    //    }];
}

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
              withFailureBlock:(FailureValueBlock)failureBlock
{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                     progress:nil
                                                                  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                      NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                                                                                            inDomain:NSUserDomainMask
                                                                                                                                   appropriateForURL:nil
                                                                                                                                              create:NO
                                                                                                                                               error:nil];
                                                                      if (response) {
                                                                          returnBlock(response);
                                                                      }
                                                                      return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                                                      
                                                                  } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                      if (failureBlock) {
                                                                          failureBlock(error);
                                                                      }
                                                                      NSLog(@"File downloaded to: %@", filePath);
                                                                  }];
    [downloadTask resume];
}

@end
