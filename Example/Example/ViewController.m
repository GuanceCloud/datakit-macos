//
//  ViewController.m
//  Example
//
//  Created by 胡蕾蕾 on 2021/8/31.
//

#import "ViewController.h"
@interface ViewController()
@property (nonatomic, strong) NSWindowController *mainAppWVC;
@property (weak) IBOutlet NSButton *loginBtn;
@property (weak) IBOutlet NSTextField *userNameTF;
@property (weak) IBOutlet NSTextField *passwordTF;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSApplication *app = [NSApplication sharedApplication];
    NSLog(@"windows = %@",app.windows);
    // Do any additional setup after loading the view.
}
- (IBAction)closeClick:(id)sender {
    [self.view.window close];
}

- (IBAction)loginClick:(id)sender {
    if (self.userNameTF.stringValue.length==0) {
        NSAlert *alert = [[NSAlert alloc]init];
        [alert addButtonWithTitle:@"ok"];
        [alert setMessageText:@"Alert"];
        [alert setInformativeText:@"user name can't be null"];
        [alert setAlertStyle:NSAlertStyleWarning];
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        return;
    }
    NSGetUncaughtExceptionHandler();

    [self.view.window close];
    
    self.mainAppWVC = [[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"MainAppWVC"];
    
    [self.mainAppWVC showWindow:self];
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
