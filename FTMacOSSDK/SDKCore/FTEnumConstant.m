//
//  FTEnumConstant.m
//  FTMobileAgent
//
//  Created by hulilei on 2022/1/20.
//  Copyright © 2022 DataFlux-cn. All rights reserved.
//

#import "FTEnumConstant.h"
#if !TARGET_OS_OSX
#import "FTMobileConfig.h"
#else
#import "FTConfig.h"
#endif
NSString * const AppStateStringMap[] = {
    [AppStateUnknown] = @"unknown",
    [AppStateStartUp] = @"startup",
    [AppStateRun] = @"run",
};
NSString * const FTStatusStringMap[] = {
    [FTStatusInfo] = @"info",
    [FTStatusWarning] = @"warning",
    [FTStatusError] = @"error",
    [FTStatusCritical] = @"critical",
    [FTStatusOk] = @"ok"
};
NSString * const FTNetworkTraceStringMap[] = {
    [FTNetworkTraceTypeZipkinMultiHeader] = @"zipkin",
    [FTNetworkTraceTypeZipkinSingleHeader] = @"zipkin",
    [FTNetworkTraceTypeJaeger] = @"jaeger",
    [FTNetworkTraceTypeDDtrace] = @"ddtrace",
    [FTNetworkTraceTypeSkywalking] = @"skywalking",
    [FTNetworkTraceTypeTraceparent] = @"traceparent",
};
NSString * const FTEnvStringMap[] = {
    [FTEnvProd] = @"prod",
    [FTEnvGray] = @"gray",
    [FTEnvPre] = @"pre",
    [FTEnvCommon] = @"common",
    [FTEnvLocal] = @"local",
};

NSTimeInterval const MonitorFrequencyMap[] = {
    [FTMonitorFrequencyDefault] = 0.5,
    [FTMonitorFrequencyRare] = 1.0,
    [FTMonitorFrequencyFrequent] = 0.1
};
