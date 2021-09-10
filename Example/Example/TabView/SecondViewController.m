//
//  SecondViewController.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/9/10.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
-(void)viewWillAppear{
    [super viewWillAppear];
    NSLog(@"SecondViewController viewWillAppear");
}
- (void)viewDidAppear{
    [super viewDidAppear];
    NSLog(@"SecondViewController viewDidAppear");

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
