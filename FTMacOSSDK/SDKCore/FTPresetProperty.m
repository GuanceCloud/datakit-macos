//
//  FTPresetProperty.m
//  Pods
//
//  Created by 胡蕾蕾 on 2021/9/9.
//

#import "FTPresetProperty.h"

@implementation FTPresetProperty
+ (NSString *)appName {
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
@end
