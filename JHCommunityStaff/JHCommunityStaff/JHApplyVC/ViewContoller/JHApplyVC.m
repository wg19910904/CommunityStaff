//
//  JHApplyVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/4.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHApplyVC.h"
#import "SelectedApplyBnt.h"
#import "JHPaoTuiApplyVC.h"
#import "JHMaintainApplyVC.h"
#import "JHHouseApplyVC.h"
@interface JHApplyVC ()

@end

@implementation JHApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self addTitle:NSLocalizedString(@"选择身份", nil)];
    [self createSelecteApplyBnt];
}
#pragma mark======搭建UI界面===========
- (void)createUI{
    UILabel *alerLabel = [[UILabel alloc] initWithFrame:FRAME(15, 15, WIDTH - 30, 30)];
    alerLabel.layer.cornerRadius = 15.0f;
    alerLabel.clipsToBounds = YES;
    alerLabel.backgroundColor = HEX(@"fff8d6", 1.0f);
    alerLabel.textAlignment = NSTextAlignmentCenter;
    alerLabel.textColor = HEX(@"ff3300", 1.0f);
    alerLabel.font = FONT(14);
    alerLabel.text = NSLocalizedString(@"每个账号只能申请一个身份", nil);
    alerLabel.layer.borderColor = HEX(@"ff3300", 1.0f).CGColor;
    alerLabel.layer.borderWidth = 0.5f;
    [self.view addSubview:alerLabel];
}
#pragma mark=====初始化选择按钮控件======
- (void)createSelecteApplyBnt{
    NSArray *titles = @[NSLocalizedString(@"维修师傅", nil),NSLocalizedString(@"家政阿姨", nil),NSLocalizedString(@"跑腿哥", nil)];
    NSArray *imgs = @[IMAGE(@"sq_weixiu"),IMAGE(@"sq_ayi"),IMAGE(@"sq_paotui")];
    CGFloat space = (WIDTH - 290) / 2;
    for(int i = 0; i < 3; i ++){
        SelectedApplyBnt *selecteApplyBnt = [[SelectedApplyBnt alloc] initWithFrame:FRAME(space + 100 * i, 280, 90, 120)];
        if(i == 1){
            CGRect rect = selecteApplyBnt.frame;
            rect.origin.y -= 165;
            selecteApplyBnt.frame = rect;
        }
        selecteApplyBnt.tag = i + 1;
        [selecteApplyBnt setTitle:titles[i] forState:UIControlStateNormal];
        [selecteApplyBnt setImage:imgs[i] forState:UIControlStateNormal];
        [selecteApplyBnt setImage:imgs[i] forState:UIControlStateHighlighted];
        [selecteApplyBnt addTarget:self action:@selector(clickSelcteApplyBnt:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:selecteApplyBnt];
    }

}
#pragma mark======选择申请按钮点击事件========
- (void)clickSelcteApplyBnt:(SelectedApplyBnt *)sender{
    if(sender.tag == 1){
        NSLog(@"维修师傅");
        JHMaintainApplyVC *mainApply = [[JHMaintainApplyVC alloc] init];
        [self.navigationController pushViewController:mainApply animated:YES];
    }else if(sender.tag == 2){
        NSLog(@"家政阿姨");
        JHHouseApplyVC *houseApply = [[JHHouseApplyVC alloc] init];
        [self.navigationController pushViewController:houseApply animated:YES];
    }else{
        NSLog(@"跑腿哥");
        JHPaoTuiApplyVC *paoTuiApply = [[JHPaoTuiApplyVC alloc] init];
        [self.navigationController pushViewController:paoTuiApply animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
