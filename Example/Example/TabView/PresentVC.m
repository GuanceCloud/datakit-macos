//
//  PresentVC.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/9/10.
//

#import "PresentVC.h"

@interface PresentVC ()

@end

@implementation PresentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}
- (IBAction)dismissClick:(id)sender {
    if (self.presentingViewController != nil) {
        [self dismissController:sender];
    } else {
        [self.view.window close];
    }
}

@end
