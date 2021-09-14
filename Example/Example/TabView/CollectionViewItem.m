//
//  CollectionViewItem.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/9/14.
//

#import "CollectionViewItem.h"

@interface CollectionViewItem ()
@property (weak) IBOutlet NSImageView *icon;
@property (weak) IBOutlet NSTextField *lable;

@end

@implementation CollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}
-(void)setRepresentedObject:(id)representedObject{
    NSDictionary *data = representedObject;
    NSString *image = data[@"image"];
    self.icon.image = [NSImage imageNamed:image];
    
    NSString *title = data[@"title"];
    self.lable.stringValue = title;
}
-(void)updateStatus{
    if (self.selected) {
        self.view.layer.backgroundColor = [NSColor lightGrayColor ].CGColor;
    }else{
        self.view.layer.backgroundColor = [NSColor whiteColor ].CGColor;
    }
}
@end
