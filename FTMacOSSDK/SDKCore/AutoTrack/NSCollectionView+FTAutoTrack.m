//
//  NSCollectionView+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/17.
//

#import "NSCollectionView+FTAutoTrack.h"
#import <FTSwizzler.h>
#import "FTGlobalRumManager.h"
#import "FTAutoTrack.h"
@implementation NSCollectionView (FTAutoTrack)

-(void)datakit_setDelegate:(id<NSCollectionViewDelegate>)delegate{
    [self datakit_setDelegate:delegate];
    
    if (self.delegate == nil) {
        return;
    }
    SEL selector = @selector(collectionView:didSelectItemsAtIndexPaths:);
    Class class = [FTSwizzler realDelegateClassFromSelector:selector proxy:delegate];
    
    if ([FTSwizzler realDelegateClass:class respondsToSelector:selector]) {
        void (^didSelectItemBlock)(id, SEL, id, id) = ^(id view, SEL command, NSCollectionView *collectionView, NSSet<NSIndexPath *> *indexPaths) {
            //  获取 view 的 viewcontroller 时 不考虑 NSCollectionViewItem
            if (collectionView && indexPaths) {
                if([FTAutoTrack sharedInstance].addRumDatasDelegate && [[FTAutoTrack sharedInstance].addRumDatasDelegate respondsToSelector:@selector(addClickActionWithName:)]){
                    [[FTAutoTrack sharedInstance].addRumDatasDelegate addClickActionWithName:self.datakit_actionName];
                }            }
        };
        
        [FTSwizzler swizzleSelector:selector
                            onClass:class
                          withBlock:didSelectItemBlock
                              named:@"collectionView_didSelect"];
    }
    
    
}
@end
@implementation NSTableView (FTAutoTrack)

-(void)datakit_setDoubleAction:(SEL)doubleAction{
    [self datakit_setDoubleAction:doubleAction];
    void (^doubleActionBlock)(void) = ^() {
        //        [[FTGlobalRumManager sharedInstance].rumManger addClickActionWithName:self.datakit_actionName];
    };
    [FTSwizzler swizzleSelector:doubleAction
                        onClass:self.class
                      withBlock:doubleActionBlock
                          named:@"tableView_doubleAction"];
}
-(NSString *)datakit_actionName{
    return [NSString stringWithFormat:@"[%@][column:%ld][row:%ld]",NSStringFromClass(self.class),self.clickedColumn,(long)self.clickedRow];
}
@end
