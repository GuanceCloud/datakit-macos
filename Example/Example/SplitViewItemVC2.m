//
//  SplitViewItemVC2.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/9/26.
//

#import "SplitViewItemVC2.h"
#import "CollectionVC.h"
#import "PresentVC.h"
#import "TabViewController.h"
@interface SplitViewItemVC2 ()
@property (nonatomic, strong) CollectionVC *mCollection;
@property (nonatomic, strong) TabViewController *mTabView;
@property (nonatomic, strong) PresentVC *mPresent;
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
-(PresentVC *)mPresent{
    if (!_mPresent) {
        _mPresent = [[PresentVC alloc]init];
    }
    return _mPresent;
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
                from = self.mPresent;
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
                to = self.mPresent;
                break;
        }
        [self transitionFromViewController:from toViewController:to options:NSViewControllerTransitionCrossfade completionHandler:^{
            self.currentIndex = index;
        }];
    }
   
}
@end
