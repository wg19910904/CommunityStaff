//
//  JHNegotiateVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/13.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHNegotiateVC.h"

@interface JHNegotiateVC ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation JHNegotiateVC
- (void)viewDidLoad {
    [super viewDidLoad];
    if([self.type isEqualToString:@"weixiu"]){
        [self addTitle:NSLocalizedString(@"维修师傅入驻协议", nil)];
    }else if ([self.type isEqualToString:@"house"]){
        [self addTitle:NSLocalizedString(@"家政阿姨入驻协议", nil)];
    }else if ([self.type isEqualToString:@"paotui"]){
        [self addTitle:NSLocalizedString(@"跑腿入驻协议", nil)];
    }
    [self initSubViews];
}
#pragma mark=======初始化子控件=======
- (void)initSubViews{
    _webView = [[UIWebView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64)];
    _webView.delegate = self;
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    NSString *str = [NSString stringWithFormat:@"http://%@/%@",KReplace_Url,@"page/staffprotocol.html"];
    NSLog(@"%@",str);
    //[_webView loadHTMLString:str baseURL:nil];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
}
@end
