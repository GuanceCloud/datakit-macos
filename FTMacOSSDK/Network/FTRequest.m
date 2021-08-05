//
//  FTRequest.m
//  FTMacOSSDK
//
//  Created by 胡蕾蕾 on 2021/8/5.
//  Copyright © 2021 DataFlux-cn. All rights reserved.
//

#import "FTRequest.h"
#import "FTRequestBody.h"

@implementation FTLoggingRequest
-(instancetype)initWithMetricsUrl:(NSString *)metricsUrl events:(NSArray<FTTrackDataModel *> *)events{
    self = [super init];
    if(self){
        self.metricsUrl = metricsUrl;
        self.events = events;
    }
    return self;
}
-(NSURL *)absoluteURL{
    if (!self.metricsUrl) {
        return nil;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.metricsUrl,self.path]];
    return url;
}
-(NSString *)path{
    return @"/v1/write/logging";
}
-(NSString *)contentType{
    return @"text/plain";
}
-(NSString *)httpMethod{
    return @"POST";
}
@end
@implementation FTRumRequest
-(instancetype)initWithMetricsUrl:(NSString *)metricsUrl events:(NSArray<FTTrackDataModel *> *)events{
    self = [super init];
    if(self){
        self.metricsUrl = metricsUrl;
        self.events = events;
    }
    return self;
}
-(NSURL *)absoluteURL{
    if (!self.metricsUrl) {
        return nil;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.metricsUrl,self.path]];
    return url;
}
-(NSString *)path{
    return @"/v1/write/rum";
}
-(NSString *)contentType{
    return @"text/plain";
}
-(NSString *)httpMethod{
    return @"POST";
}
@end
@implementation FTTracingRequest 
-(instancetype)initWithMetricsUrl:(NSString *)metricsUrl events:(NSArray<FTTrackDataModel *> *)events{
    self = [super init];
    if(self){
        self.metricsUrl = metricsUrl;
        self.events = events;
    }
    return self;
}
-(NSURL *)absoluteURL{
    if (!self.metricsUrl) {
        return nil;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.metricsUrl,self.path]];
    return url;
}
-(NSString *)path{
    return @"/v1/write/tracing";
}
-(NSString *)contentType{
    return @"text/plain";
}
-(NSString *)httpMethod{
    return @"POST";
}
@end
@implementation FTObjectRequest

-(instancetype)initWithMetricsUrl:(NSString *)metricsUrl events:(NSArray<FTTrackDataModel *> *)events{
    self = [super init];
    if(self){
        self.metricsUrl = metricsUrl;
        self.events = events;
    }
    return self;
}
-(NSURL *)absoluteURL{
    if (!self.metricsUrl) {
        return nil;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.metricsUrl,self.path]];
    return url;
}
-(NSString *)path{
    return @"/v1/write/object";
}
-(NSString *)contentType{
    return @"application/json";
}
-(NSString *)httpMethod{
    return @"POST";
}
@end
