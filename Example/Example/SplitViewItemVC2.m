//
//  SplitViewItemVC2.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/9/26.
//

#import "SplitViewItemVC2.h"
#import "CollectionVC.h"
#import "RumViewController.h"
#import "TabViewController.h"
@interface SplitViewItemVC2 ()
@property (nonatomic, strong) CollectionVC *mCollection;
@property (nonatomic, strong) TabViewController *mTabView;
@property (nonatomic, strong) RumViewController *mRumVC;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation SplitViewItemVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self insertChildViewController:self.mCollection atIndex:0];
    [self insertChildViewController:self.mTabView atIndex:1];
    [self insertChildViewController:self.mPresent atIndex:2];

    [self.view addSubview:self.mCollection.view];
}
- (CollectionVC *)mCollection{
    if(!_mCollection){
        _mCollection = [[CollectionVC alloc]init];
    }
    return _mCollection;
}
-(RumViewController *)mPresent{
    if (!_mRumVC) {
        _mRumVC = [[RumViewController alloc]init];
    }
    return _mRumVC;
}
-(TabViewController *)mTabView{
    if (!_mTabView) {
        _mTabView = [[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"TabViewController"];
    }
    return _mTabView;
}
-(void)showViewIndex:(NSInteger)index{
    if (self.currentIndex != index) {
        NSViewController *from,*to = nil;
        switch (self.currentIndex) {
            case 0:
                from = self.mCollection;
                break;
            case 1:
                from = self.mTabView;
                break;
            default:
                from = self.mRumVC;
                break;
        }
        
        switch (index) {
            case 0:
                to = self.mCollection;
                break;
            case 1:
                to = self.mTabView;
                break;
            default:
                to = self.mRumVC;
                break;
        }
        [self transitionFromViewController:from toViewController:to options:NSViewControllerTransitionCrossfade completionHandler:^{
            self.currentIndex = index;
        }];
    }
   
}
@end
