//
//  TabViewController.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/9/10.
//

#import "TabViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "PresentVC.h"
#import "PresentCustomAnimator.h"
#import "CollectionVC.h"

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
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = NSColor.redColor.CGColor;

    NSArray *tabItems = self.tabView.tabViewItems;
    self.tabView.delegate = self;
    FirstViewController *vc1 = [[FirstViewController alloc]init];
    SecondViewController *vc2 = [[SecondViewController alloc]init];
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    NSArray *vcs = @[vc1,vc2];
    int index = 0;
    for (NSTabViewItem *item in tabItems) {
        NSViewController *vc = vcs[index];
        [item.view addSubview:vc.view];
        vc.view.frame = item.view.bounds;
        index = index+1;
    }
    NSImageView *view = [[NSImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
//    [view prepareForReuse];
    // 背景色
    view.wantsLayer = YES;
    view.layer.backgroundColor = NSColor.redColor.CGColor;
    // 圆角
    view.layer.cornerRadius = 15;
    // 边框
    view.layer.borderColor = NSColor.greenColor.CGColor;
    view.layer.borderWidth = 2;
    NSClickGestureRecognizer *gesture = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
    [view addGestureRecognizer:gesture];
    [self.view addSubview:view];
}
- (void)viewClick:(NSGestureRecognizer *)gesture {
    NSLog(@"touch view");
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
    NSApplication *app = [NSApplication sharedApplication];
    NSLog(@"windows = %@",app.windows);
}
- (IBAction)modalClick:(id)sender {
    
    CollectionVC *vc = [[CollectionVC alloc]init];
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
    PresentVC *presentVC = [[PresentVC alloc]init];

//    let toVC = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ToVC")) as? NSViewController
//    //增加 2个子视图控制器
    presentVC.view.wantsLayer = YES;
//    presentVC?.view.layer?.backgroundColor = NSColor.white.cgColor
//    self.addChildViewController(presentVC!)
//    self.view.addSubview((presentVC?.view)!)
//
    [self addChildViewController:presentVC];
//    self.addChildViewController(toVC!)
    //显示 presentVC 视图
    // 从 presentVC 视图 切换到另外一个 toVC 视图
//        self.transition(from: presentVC!, to: toVC!, options: NSViewController.TransitionOptions.crossfade , completionHandler: nil)
//    NSColorPanel *color = [[NSColorPanel alloc]init];
//    [self.view.window beginSheet:color completionHandler:^(NSModalResponse returnCode) {
//
//    }];
//    NSOpenPanel *open = [NSOpenPanel openPanel];
//    open.canChooseFiles = YES;
//    [open beginWithCompletionHandler:^(NSModalResponse result) {
//        if(result == NSModalResponseOK){
//            NSArray *filesUrl = open.URLs;
//            for (NSURL *url in filesUrl) {
//                NSError *error;
//                NSString *string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
//                NSLog(@"fileUrl = %@",string);
//            }
//        }
//    }];
}

- (IBAction)segmentClick:(id)sender {

}
-(void)viewDidDisappear{
    [super viewDidDisappear];
    
}
@end
