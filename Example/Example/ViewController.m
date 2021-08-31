//
//  ViewController.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/8/31.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)createUI{
    NSButton *button = [[NSButton alloc]initWithFrame:CGRectMake(20, 20, 100, 40)];
    [button setTitle:@"click"];
    [self.view addSubview:button];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
