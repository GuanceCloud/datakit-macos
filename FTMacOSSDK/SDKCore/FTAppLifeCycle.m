//
//  FTAppLifeCycle.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/17.
//

#import "FTAppLifeCycle.h"
@interface FTAppLifeCycle()
@property(strong, nonatomic, readonly) NSPointerArray *appLifecycleDelegates;
@property(strong, nonatomic, readonly) NSLock *delegateLock;
@end
@implementation FTAppLifeCycle
-(instancetype)init{
    self = [super init];
    if (self) {
        _appLifecycleDelegates = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];
        _delegateLock = [[NSLock alloc] init];
        [self setupAppStateNotification];
    }
    return self;
}
+ (instancetype)sharedInstance{
    static FTAppLifeCycle *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}
- (void)addAppLifecycleDelegate:(id<FTAppLifeCycleDelegate>)delegate {
    [self.delegateLock lock];
    if (![self.appLifecycleDelegates.allObjects containsObject:delegate]) {
        [self.appLifecycleDelegates addPointer:(__bridge void *)delegate];
    }
    [self.delegateLock unlock];
}
- (void)removeAppLifecycleDelegate:(id<FTAppLifeCycleDelegate>)delegate{
    [self.delegateLock lock];
    [self.appLifecycleDelegates.allObjects
            enumerateObjectsWithOptions:NSEnumerationReverse
                             usingBlock:^(NSObject *obj, NSUInteger idx, BOOL *_Nonnull stop) {
                                 if (delegate == obj) {
                                     [self.appLifecycleDelegates removePointerAtIndex:idx];
                                     *stop = YES;
                                 }
                             }];
    [self.delegateLock unlock];
}
- (void)setupAppStateNotification{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    
  
    [notification addObserver:self selector:@selector(applicationDidBecomeActiveNotification:) name:NSApplicationDidBecomeActiveNotification object:[NSApplication sharedApplication]];
    
    [notification addObserver:self selector:@selector(applicationWillResignActiveNotification:) name:NSApplicationWillResignActiveNotification object:[NSApplication sharedApplication]];
    
    [notification addObserver:self selector:@selector(applicationWillTerminateNotification:) name:NSApplicationWillTerminateNotification object:[NSApplication sharedApplication]];
}

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification{
    [self.delegateLock lock];
    for (id delegate in self.appLifecycleDelegates) {
        if ([delegate respondsToSelector:@selector(applicationDidBecomeActive)]) {
            [delegate applicationDidBecomeActive];
        }
    }
    [self.delegateLock unlock];
}
- (void)applicationWillResignActiveNotification:(NSNotification *)notification{
    [self.delegateLock lock];
    for (id delegate in self.appLifecycleDelegates) {
        if ([delegate respondsToSelector:@selector(applicationWillResignActive)]) {
            [delegate applicationWillResignActive];
        }
    }
    [self.delegateLock unlock];
}

- (void)applicationWillTerminateNotification:(NSNotification *)notification{
    [self.delegateLock lock];
    for (id delegate in self.appLifecycleDelegates) {
        if ([delegate respondsToSelector:@selector(applicationWillTerminate)]) {
            [delegate applicationWillTerminate];
        }
    }
    [self.delegateLock unlock];
}
@end
