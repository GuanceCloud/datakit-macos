//
//  FirstViewController.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/9/10.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
-(void)viewWillAppear{
    [super viewWillAppear];
    NSLog(@"FirstViewController viewWillAppear");

}
- (void)viewDidAppear{
    [super viewDidAppear];
    NSLog(@"FirstViewController viewDidAppear");

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do view setup here.
}

@end
