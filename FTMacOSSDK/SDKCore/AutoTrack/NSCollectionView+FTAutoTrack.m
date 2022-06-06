//
//  NSCollectionView+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/17.
//

#import "NSCollectionView+FTAutoTrack.h"
#import "FTSwizzler.h"
#import "FTRumManager.h"
#import "FTGlobalRumManager.h"

@implementation NSCollectionView (FTAutoTrack)

-(void)dataflux_setDelegate:(id<NSCollectionViewDelegate>)delegate{
    [self dataflux_setDelegate:delegate];
    
    if (self.delegate == nil) {
        return;
    }
    SEL selector = @selector(collectionView:didSelectItemsAtIndexPaths:);
    Class class = [FTSwizzler realDelegateClassFromSelector:selector proxy:delegate];
    
    if ([FTSwizzler realDelegateClass:class respondsToSelector:selector]) {
        void (^didSelectItemBlock)(id, SEL, id, id) = ^(id view, SEL command, NSCollectionView *collectionView, NSSet<NSIndexPath *> *indexPaths) {
            //  获取 view 的 viewcontroller 时 不考虑 NSCollectionViewItem
            if (collectionView && indexPaths) {
                [[FTGlobalRumManager sharedInstance].rumManger addClickActionWithName:self.dataflux_actionName];
            }
        };
        
        [FTSwizzler swizzleSelector:selector
                            onClass:class
                          withBlock:didSelectItemBlock
                              named:@"collectionView_didSelect"];
    }
    
    
}
@end
@implementation NSTableView (FTAutoTrack)

-(void)dataflux_setDoubleAction:(SEL)doubleAction{
    [self dataflux_setDoubleAction:doubleAction];
    void (^doubleActionBlock)(void) = ^() {
        [[FTGlobalRumManager sharedInstance].rumManger addClickActionWithName:self.dataflux_actionName];
    };
    [FTSwizzler swizzleSelector:doubleAction
                        onClass:self.class
                      withBlock:doubleActionBlock
                          named:@"tableView_doubleAction"];
}
-(NSString *)dataflux_actionName{
    return [NSString stringWithFormat:@"[%@][column:%ld][row:%ld]",NSStringFromClass(self.class),self.clickedColumn,(long)self.clickedRow];
}
@end
