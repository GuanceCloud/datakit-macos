//
//  NSWindow+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import "NSWindow+FTAutoTrack.h"
#import "FTSwizzler.h"

@implementation NSWindow (FTAutoTrack)
-(instancetype)dataflux_init{
    NSWindow *win = [self dataflux_init];
    NSLog(@"\n ==================\nNSWindow init= %@\n ==================",NSStringFromClass([win class]));
    return win;
}
-(instancetype)dataflux_initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag{
    NSWindow *win = [self dataflux_initWithContentRect:contentRect styleMask:style backing:backingStoreType defer:flag];
    NSLog(@"\n ==================\nft_initWithContentRect init= %@\n ==================",NSStringFromClass([win class]));
    NSLog(@"\n ==================\n contentViewController = %@\n ==================",win.contentViewController);

    return win;
}
- (instancetype)dataflux_initWithCoder:(NSCoder *)coder{
    NSWindow *win = [self dataflux_initWithCoder:coder];
    NSLog(@"\n ==================\nft_initWithCoder init= %@\n ==================",NSStringFromClass([win class]));

    return win;
    
}


-(void)dataflux_close{
    [self dataflux_close];
}
@end
