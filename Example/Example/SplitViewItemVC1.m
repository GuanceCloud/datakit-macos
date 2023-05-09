//
//  SplitViewItemVC1.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/9/26.
//

#import "SplitViewItemVC1.h"
#import "SplitViewVC.h"
#import "FTMacOSSDK.h"
#import "Example-Swift.h"
@interface SplitViewItemVC1 ()<NSTableViewDelegate,NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *mTableview;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation SplitViewItemVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
    SplitViewVC *parent = (SplitViewVC *)self.parentViewController;
    self.delegate = parent;
    self.datas = @[@"AutoTrack Click",@"RUM数据采集",@"日志输出",@"网络链路追踪",@"绑定用户",@"解绑用户",@"控制台日志采集"];
    self.mTableview.backgroundColor = [NSColor whiteColor];
    self.mTableview.usesAlternatingRowBackgroundColors = YES;
    [self.mTableview setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
    self.mTableview.dataSource = self;
    self.mTableview.delegate = self;
    self.mTableview.allowsMultipleSelection = NO;
    [self.mTableview reloadData];
}
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return  self.datas.count;
}
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSString *data = self.datas[row];
    NSString *key = tableColumn.identifier;
    //单元格数据
    
    //根据表格列的标识,创建单元视图
    NSView *view = [tableView makeViewWithIdentifier:key owner:self];
   
    if (view == nil) {
    
        NSTableCellView *cellView = [NSTableCellView alloc].init;
        
        view = cellView;
        NSTextField *textField =  [NSTextField alloc].init;
        textField.tag = 200+row;
        textField.translatesAutoresizingMaskIntoConstraints = NO;
        [textField setBezeled:NO];
        textField.drawsBackground = NO;

//        [cellView addSubview:textField];
        cellView.textField = textField;

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

    if (data != nil) {
        textField.stringValue = data;
    }
    
    return view;
}
-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    NSInteger row = [notification.object selectedRow];
    if(row == 4){
        [[FTSDKAgent sharedInstance] bindUserWithUserID:@"macosid01" userName:@"macos_user" userEmail:@"macos_user@123.com" extra:@{@"user_extra":@"user_extra_demo"}];
        return;
    }else if(row == 5){
        [[FTSDKAgent sharedInstance] unbindUser];
        return;
    }else if(row == 6){
        NSLog(@"NSLog Console log");
        LogTest *test = [[LogTest alloc]init];
        [test show];
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(tableViewSelectionDidSelect:)]) {
        [self.delegate tableViewSelectionDidSelect:row];
    }
}

@end
