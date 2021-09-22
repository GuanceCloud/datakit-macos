//
//  FTBaseInfoHander.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/22.
//

#import "FTBaseInfoHander.h"

@implementation FTBaseInfoHander
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
@end
