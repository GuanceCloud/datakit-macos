//
//  ViewController.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/8/31.
//

#import "ViewController.h"
@interface ViewController()
@property (nonatomic, strong) NSWindowController *mainAppWVC;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    NSButton *button = [NSButton buttonWithTitle:@"Login" target:self action:@selector(click)];
    
    [self.view addSubview:button];
}
- (void)click{
    [self.view.window close];
    
    self.mainAppWVC = [[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"MainAppWVC"];
    
    [self.mainAppWVC showWindow:self];
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
