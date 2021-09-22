//
//  FTDeviceInfo.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/17.
//

#import "FTDeviceInfo.h"
#import <IOKit/IOKitLib.h>
#include <sys/sysctl.h>
#import "FTLog.h"
@implementation FTDeviceInfo
+ (instancetype)sharedInstance{
    static FTDeviceInfo *shares = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shares = [[FTDeviceInfo alloc]init];
    });
    return shares;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        _screenSize = [self deviceScreenSize];
        _osVersion = [self systermVersion];
        _os = @"macOS";
        _device = @"APPLE";
        _deviceUUID = [self getDeviceUUID];
        _model = [self deviceModel];
    }
    return self;
}
- (NSString *)deviceScreenSize{
    NSScreen *screen = [NSScreen mainScreen];
    return [NSString stringWithFormat:@"%f*%f",screen.frame.size.width,screen.frame.size.height];
}

- (NSString *)appName {
    NSString *displayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (displayName.length > 0) {
        return displayName;
    }
    
    NSString *bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    if (bundleName.length > 0) {
        return bundleName;
    }
    
    NSString *executableName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
    if (executableName) {
        return executableName;
    }
    
    return nil;
}
- (NSString *)appIdentifier{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}
- (NSString *)getDeviceUUID{
    io_registry_entry_t ioRegistryRoot = IORegistryEntryFromPath(kIOMasterPortDefault, "IOService:/");
    CFStringRef uuidCf = (CFStringRef) IORegistryEntryCreateCFProperty(ioRegistryRoot, CFSTR(kIOPlatformUUIDKey), kCFAllocatorDefault, 0);
    IOObjectRelease(ioRegistryRoot);
    NSString * uuid = (__bridge NSString *)uuidCf;
    CFRelease(uuidCf);
    return uuid;
}
- (NSString *)systermVersion{
    NSProcessInfo *info = [NSProcessInfo processInfo];
    NSInteger major = info.operatingSystemVersion.majorVersion;
    NSInteger minor = info.operatingSystemVersion.minorVersion;
    NSInteger patch = info.operatingSystemVersion.patchVersion;
    return  [NSString stringWithFormat:@"%ld.%ld.%ld",major,minor,patch];
}
- (NSString *)deviceModel {
    NSString *result = nil;
    @try {
        NSString *hwName = @"hw.machine";
        size_t size;
        sysctlbyname([hwName UTF8String], NULL, &size, NULL, 0);
        char answer[size];
        sysctlbyname([hwName UTF8String], answer, &size, NULL, 0);
        if (size) {
            result = @(answer);
        } else {
            ZYErrorLog(@"Failed fetch %@ from sysctl.", hwName);
        }
    } @catch (NSException *exception) {
        ZYErrorLog(@"%@: %@", self, exception);
    }
    return result;
}
@end
