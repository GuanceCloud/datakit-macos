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
@end
@implementation FTNetworkManager
+ (instancetype)sharedInstance {
    return [self shareManagerURLSession:[NSURLSession sharedSession]];
}
+ (instancetype)shareManagerURLSession:(id)session{
    static FTNetworkManager *manger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[FTNetworkManager alloc]init];
        manger.session = session;
    });
    return manger;
}
- (NSURLSessionDataTask *)sendRequest:(id)request
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
            
            if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
                
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
- (NSURLRequest *)createRequest:(id)request{
    
    return request;
}
@end
