//
//  TabViewController.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/9/10.
//

#import "TabViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import <FTMacOSSDK/NSApplication+FTAutotrack.h>
#import "PresentVC.h"
#import "PresentCustomAnimator.h"
@interface TabViewController ()<NSTabViewDelegate>
@property (weak) IBOutlet NSTabView *tabView;

@end

@implementation TabViewController
-(void)viewWillAppear{
    [super viewWillAppear];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    NSArray *tabItems = self.tabView.tabViewItems;
    self.tabView.delegate = self;
    FirstViewController *vc1 = [[FirstViewController alloc]init];
    SecondViewController *vc2 = [[SecondViewController alloc]init];
    NSArray *vcs = @[vc1,vc2];
    int index = 0;
    for (NSTabViewItem *item in tabItems) {
        NSViewController *vc = vcs[index];
        [item.view addSubview:vc.view];
        vc.view.frame = item.view.bounds;
        index = index+1;
    }
}

-(void)tabView:(NSTabView *)tabView didSelectTabViewItem: (NSTabViewItem* )tabViewItem{
    NSInteger index = [tabView indexOfTabViewItem:tabViewItem];
     id view = tabViewItem.view.nextResponder;
    while (view !=nil) {
        if ([view isKindOfClass:NSViewController.class]) {
            break;
            
        }else if ([view isKindOfClass:NSView.class]){
            NSView *nView = view;
            view = nView.nextResponder;
        }
    }
    NSLog(@"index = %ld tabViewItem.lable = %@ controller = %@",(long)index,tabViewItem.label,view);
}
- (IBAction)modalClick:(id)sender {
    
    PresentVC *vc = [[PresentVC alloc]init];
    [self presentViewControllerAsModalWindow:vc];
}
- (IBAction)sheetClick:(id)sender {
    
    PresentVC *vc = [[PresentVC alloc]init];
    [self presentViewControllerAsSheet:vc];
}
- (IBAction)popoverClick:(id)sender {
    NSButton *btn = sender;
    PresentVC *vc = [[PresentVC alloc]init];
    [self presentViewController:vc asPopoverRelativeToRect:btn.frame ofView:self.view preferredEdge:NSRectEdgeMinY behavior:NSPopoverBehaviorTransient];
}
- (IBAction)animatorClick:(id)sender {
    PresentVC *vc = [[PresentVC alloc]init];

    PresentCustomAnimator *animator = [[PresentCustomAnimator alloc]init];
    
    [self presentViewController:vc animator:animator];
}
- (IBAction)showClick:(id)sender {
    
}

@end
