//
//  PresentVC.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/9/10.
//

#import "PresentVC.h"

@interface PresentVC ()<NSTableViewDataSource,NSTableViewDelegate>
@property (weak) IBOutlet NSTableView *mTableView;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation PresentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self createUI];
}
- (void)createUI{
    self.datas = @[@{@"id":@1,@"name":@"john",@"address":@"USA"},
                   @{@"id":@2,@"name":@"mary",@"address":@"China"},
                   @{@"id":@3,@"name":@"park",@"address":@"Russia"},
                   @{@"id":@4,@"name":@"daba",@"address":@"China"}];
    self.mTableView.backgroundColor = [NSColor redColor];
    self.mTableView.usesAlternatingRowBackgroundColors = YES;
    [self.mTableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    [self.mTableView reloadData];
    
}
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return  self.datas.count;
}
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSDictionary *data = self.datas[row];
    NSString *key = tableColumn.identifier;
    //单元格数据
    NSString *value = [NSString stringWithFormat:@"%@", data[key]];
    
    //根据表格列的标识,创建单元视图
    NSView *view = [tableView makeViewWithIdentifier:key owner:self];
   
    if (view == nil) {
    
        NSTableCellView *cellView = [NSTableCellView alloc].init;
        view = cellView;
        
        NSTextField *textField =  [NSTextField alloc].init;
        textField.translatesAutoresizingMaskIntoConstraints = NO;
        [textField setBezeled:NO];
        textField.drawsBackground = NO;

        [cellView addSubview:textField];
        
        NSLayoutConstraint *topAnchor = [textField.topAnchor constraintEqualToAnchor:cellView.topAnchor constant:0];
        NSLayoutConstraint *bottomAnchor = [textField.bottomAnchor constraintEqualToAnchor:cellView.bottomAnchor constant:0];

        NSLayoutConstraint *leftAnchor = [textField.leftAnchor constraintEqualToAnchor:cellView.leftAnchor constant:0];

        NSLayoutConstraint *rightAnchor = [textField.rightAnchor constraintEqualToAnchor:cellView.rightAnchor constant:0];

        [NSLayoutConstraint activateConstraints:@[topAnchor,bottomAnchor,leftAnchor, rightAnchor]];
    }
    
    NSArray *subviews = view.subviews;
    if (subviews.count <= 0){
        return nil;
    }
    
    NSTextField *textField = subviews[0];

    if (value != nil) {
        textField.stringValue = value;
    }
    
    return view;
}
- (IBAction)dismissClick:(id)sender {
    if (self.presentingViewController != nil) {
        [self dismissController:sender];
    } else {
        [self.view.window close];
    }
}

@end
