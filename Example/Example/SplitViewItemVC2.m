//
//  SplitViewItemVC2.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/9/26.
//

#import "SplitViewItemVC2.h"
#import "RumViewController.h"
#import "TabViewController.h"
#import "LoggingViewController.h"
#import "TraceViewController.h"
@interface SplitViewItemVC2 ()
@property (nonatomic, strong) TabViewController *mTabView;
@property (nonatomic, strong) RumViewController *mRumVC;
@property (nonatomic, strong) LoggingViewController *mLoggerVC;
@property (nonatomic, strong) TraceViewController *mTraceVC;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation SplitViewItemVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self insertChildViewController:self.mTabView atIndex:0];
    [self insertChildViewController:self.mPresent atIndex:1];
    [self insertChildViewController:self.mLoggerVC atIndex:2];
    [self insertChildViewController:self.mTraceVC atIndex:3];
    [self.view addSubview:self.mTabView.view];
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
-(LoggingViewController *)mLoggerVC{
    if (!_mLoggerVC) {
        _mLoggerVC = [[LoggingViewController alloc]init];
    }
    return _mLoggerVC;
}
-(TraceViewController *)mTraceVC{
    if(!_mTraceVC){
        _mTraceVC = [[TraceViewController alloc]init];
    }
    return _mTraceVC;
}
-(void)showViewIndex:(NSInteger)index{
    if (self.currentIndex != index) {
        NSViewController *from = [self getIndexVC:self.currentIndex];
        NSViewController *to = [self getIndexVC:index];
        [self transitionFromViewController:from toViewController:to options:NSViewControllerTransitionCrossfade completionHandler:^{
            self.currentIndex = index;
        }];
    }
   
}
- (NSViewController *)getIndexVC:(NSInteger)index{
    NSViewController *back;
    switch (index) {
        case 0:
            back = self.mTabView;
            break;
        case 1:
            back = self.mRumVC;
            break;
        case 2:
            back = self.mLoggerVC;
            break;
        case 3:
            back = self.mTraceVC;
            break;
        default:
            break;
    }
    return back;
}
@end
