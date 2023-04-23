//
//  NSMenuItem+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/28.
//

#import "NSMenuItem+FTAutoTrack.h"

@implementation NSMenuItem (FTAutoTrack)
-(NSString *)datakit_actionName{
    return [NSString stringWithFormat:@"[NSMenuItem]%@",self.title];
}
@end
