//
//  SecondViewController.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/9/10.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property (weak) IBOutlet NSTextField *lable;
@property (weak) IBOutlet NSImageView *imageView;

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
    NSLog(@"SecondViewController viewDidAppear");
    NSClickGestureRecognizer *tap = [[NSClickGestureRecognizer alloc]init];
    tap.action = @selector(lableTap);
    [self.lable addGestureRecognizer:tap];
    // 设置背景色
    self.imageView.wantsLayer = YES;
    self.imageView.layer.backgroundColor = NSColor.redColor.CGColor;
    // 设置圆角
    self.imageView.layer.cornerRadius = 10;
    // 设置边框
    self.imageView.layer.borderColor = NSColor.redColor.CGColor;
    self.imageView.layer.borderWidth = 5;
  
    NSClickGestureRecognizer *gesture = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
    gesture.numberOfClicksRequired = 1;
    [self.imageView addGestureRecognizer:gesture];
}
- (void)lableTap{
    NSLog(@"lableTap NSGestureRecognizer set action");
}
- (void)imageViewClick:(NSClickGestureRecognizer *)ges{
    NSLog(@"imageTap NSGestureRecognizer init action");
}
- (IBAction)slider:(id)sender {
    NSLog(@"slider = %@",sender);
}
- (void)viewDidDisappear{
    [super viewDidDisappear];
    NSLog(@"SecondViewController viewDidDisappear");

}
@end
