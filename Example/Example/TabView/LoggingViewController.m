//
//  LoggingViewController.m
//  Example
//
//  Created by hulilei on 2023/4/3.
//

#import "LoggingViewController.h"
#import <FTMacOSSDK/FTMacOSSDK.h>

@interface LoggingViewController ()<NSTableViewDataSource,NSTableViewDelegate>
@property (strong) IBOutlet NSTableView *mTableView;
@property (nonatomic, strong) NSArray *datas;

@end
@implementation LoggingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self createUI];
}
- (void)createUI{
    self.datas = @[@{@"Logging":@"Log Status: info"},
                   @{@"Logging":@"Log Status: warning"},
                   @{@"Logging":@"Log Status: error"},
                   @{@"Logging":@"Log Status: critical"},
                   @{@"Logging":@"Log Status: ok"},
    ];
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
        textField.maximumNumberOfLines = 3;
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

-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    switch (self.mTableView.selectedRow) {
        case 0:
            [[FTSDKAgent sharedInstance] logging:@"info log content" status:FTStatusInfo];
            break;
        case 1:
            [[FTSDKAgent sharedInstance] logging:@"warning log content" status:FTStatusWarning];

            break;
        case 2:
            [[FTSDKAgent sharedInstance] logging:@"error log content" status:FTStatusError];
            break;
        case 3:
            [[FTSDKAgent sharedInstance] logging:@"critical log content" status:FTStatusCritical];

            break;
        case 4:
            [[FTSDKAgent sharedInstance] logging:@"ok log content" status:FTStatusOk];

            break;
        default:
            break;
    }
}

@end
