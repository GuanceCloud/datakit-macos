//
//  TestRumWebView.m
//  FTMacOSSDKTests
//
//  Created by hulilei on 2023/10/9.
//

#import "TestRumWebView.h"
@interface TestRumWebView()<WKUIDelegate>

@end
@implementation TestRumWebView
-(void)loadView{
    self.view = [[NSView alloc]initWithFrame:NSMakeRect(0, 0, 1000, 800)];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self loadWebView];
}
- (void)loadWebView{
    WKUserContentController *userContentController = WKUserContentController.new;
    NSString *cookieSource = [NSString stringWithFormat:@"document.cookie = 'user=%@';", @"userValue"];

    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieSource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = userContentController;
        
    //! 使用configuration对象初始化webView
    self.mWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:self.mWebView];
    
}
- (void)test_loadUrl{
    NSURL *url =  [[NSBundle mainBundle] URLForResource:@"sample" withExtension:@"html"];
    [self.mWebView loadFileURL:url allowingReadAccessToURL:url];
}
- (void)test_addWebViewRumView:(void(^)(void))complete{
    [self.mWebView evaluateJavaScript:@"testRumView()" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        //js函数调用return,这里才会有东西,否则无任何信息。
        NSLog(@"response: %@ error: %@", response, error);
        if(complete){
            complete();
        }
    }];

}
@end
