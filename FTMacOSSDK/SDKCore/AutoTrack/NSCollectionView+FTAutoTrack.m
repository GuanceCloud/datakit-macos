//
//  NSCollectionView+FTAutoTrack.m
//  FTMacOSSDK-framework
//
//  Created by 胡蕾蕾 on 2021/9/17.
//

#import "NSCollectionView+FTAutoTrack.h"
#import "FTSwizzler.h"
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
                NSCollectionViewItem *item = [collectionView itemAtIndexPath:[[indexPaths allObjects] firstObject]];
                NSString *actionName = [NSString stringWithFormat:@"[%@]",NSStringFromClass(collectionView.class)];
                if(item.title.length>0){
                    actionName = [NSString stringWithFormat:@"[%@]%@",NSStringFromClass(collectionView.class),item.title];
                }
                if([FTAutoTrack sharedInstance].addRumDatasDelegate && [[FTAutoTrack sharedInstance].addRumDatasDelegate respondsToSelector:@selector(addClickActionWithName:)]){
                    [[FTAutoTrack sharedInstance].addRumDatasDelegate addClickActionWithName:actionName];
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

-(NSString *)datakit_actionName{
    NSView *itemView =  [self viewAtColumn:self.clickedColumn row:self.clickedRow makeIfNecessary:NO];
    NSString *title = nil;
    if(itemView && itemView.subviews.count>0){
        for (NSView *sub in itemView.subviews) {
            if([sub isKindOfClass:NSTextField.class]){
                NSTextField *lable = (NSTextField *)sub;
                title = lable.stringValue;
            }
        }
    }
    return title?[NSString stringWithFormat:@"[%@]%@",NSStringFromClass(self.class),title]:[NSString stringWithFormat:@"[%@][column:%ld][row:%ld]",NSStringFromClass(self.class),self.clickedColumn,(long)self.clickedRow];
}
@end
