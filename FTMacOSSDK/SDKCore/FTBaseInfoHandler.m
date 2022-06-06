//
//  FTBaseInfoHander.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/22.
//

#import "FTBaseInfoHandler.h"

@implementation FTBaseInfoHandler
+ (BOOL)randomSampling:(int)sampling{
    if(sampling<=0){
        return NO;
    }
    if(sampling<100){
        int x = arc4random() % 100;
        return x <= sampling ? YES:NO;
    }
    return YES;
}
+ (NSString *)boolStr:(BOOL)isTrue{
    return isTrue?@"true":@"false";
}
+ (void)performBlockDispatchMainSyncSafe:(DISPATCH_NOESCAPE dispatch_block_t)block{
    if (NSThread.isMainThread) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
@end
