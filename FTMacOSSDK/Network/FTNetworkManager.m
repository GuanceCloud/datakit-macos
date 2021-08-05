//
//  FTNetworkManager.m
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/2.
//  Copyright © 2021 DataFlux-cn. All rights reserved.
//

#import "FTNetworkManager.h"

@interface FTNetworkManager()
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end
@implementation FTNetworkManager
+ (instancetype)sharedInstance {
    return [self shareManagerURLSession:[NSURLSession sharedSession]];
}
+ (instancetype)shareManagerURLSession:(NSURLSession *)session{
    static FTNetworkManager *manger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[FTNetworkManager alloc]init];
        manger.session = session;
    });
    return manger;
}
- (NSURLSessionDataTask *)sendRequest:(id<FTRequestProtocol>)request
                                              success:(FTNetworkSuccessBlock)success
                                              failure:(FTNetworkFailureBlock)failure {
    
    NSURLRequest *urlRequest = [self createRequest:request];
    
    NSURLSessionDataTask  *task =
    
    [self.session dataTaskWithRequest:urlRequest
                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (failure) {
                    failure(httpResponse, data, error);
                }
                return;
            }
            
            if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 500) {
                
                if (success) {
                    success(httpResponse, data);
                }
            } else {
                if (failure) {
                    failure(httpResponse, data, error);
                }
            }
        });
    }];
    
    [task resume];
    
    return task;
}
- (NSURLRequest *)createRequest:(id<FTRequestProtocol>)request{
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:request.absoluteURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    urlRequest.HTTPMethod = request.httpMethod;
    
    return urlRequest;
}

- (void)sendRequest:(id<FTRequestProtocol>  _Nonnull)request
         completion:(void(^_Nullable)(NSHTTPURLResponse * _Nonnull httpResponse,
                                      NSData * _Nullable data,
                                      NSError * _Nullable error))callback{
    [self sendRequest:request success:^(NSHTTPURLResponse * _Nonnull httpResponse, NSData * _Nonnull data) {
        if (callback) callback(httpResponse,data,nil);
    } failure:^(NSHTTPURLResponse * _Nonnull httpResponse, NSData * _Nonnull data, NSError * _Nonnull error) {
        if (callback) callback(httpResponse,data,error);
    }];
}
@end
