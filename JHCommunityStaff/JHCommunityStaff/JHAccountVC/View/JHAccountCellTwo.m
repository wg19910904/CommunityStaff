//
//  JHAccountCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/8/26.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHAccountCellTwo.h"
@implementation JHAccountCellTwo
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}
#pragma mark--===初始化子控件
- (void)initSubViews{
    self.leftTitle = [[UILabel alloc] initWithFrame:FRAME(15, 14.5, 150, 15)];
    self.leftTitle.font = FONT(14);
   self.leftTitle.textColor = HEX(@"333333", 1.0f);
    [self.contentView addSubview:self.leftTitle];
    
    self.rightTitle = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 82, 14.5, 50, 15)];
    self.rightTitle.textColor = THEME_COLOR;
    self.rightTitle.font = FONT(14);
    self.rightTitle.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rightTitle];
    
    self.dirImg = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 22, 16, 7, 12)];
    self.dirImg.image = IMAGE(@"arrow_right");
    [self.contentView addSubview:self.dirImg];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:FRAME(0, 43.5, WIDTH, 0.5)];
    bottomLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:bottomLine];
    
    UIView *topLine = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
    topLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:topLine];
}
- (void)setInfoModel:(InfoModel *)infoModel indexPath:(NSIndexPath *)indexPath{
    _infoModel = infoModel;
    _indexPath = indexPath;
    switch (indexPath.section) {
        case 1:
        {
            self.leftTitle.text = NSLocalizedString(@"性别", nil);
            self.rightTitle.hidden = NO;
            if([infoModel.sex isEqualToString:@"1"]){
                self.rightTitle.text = NSLocalizedString(@"男", nil);
            }else if([infoModel.sex isEqualToString:@"2"]){
                self.rightTitle.text = NSLocalizedString(@"女", nil);
            }else{
                self.rightTitle.text = NSLocalizedString(@"去设置", nil);
            }
        }
            break;
        case 2:
        {
            self.leftTitle.textColor = HEX(@"999999", 1.0f);
            if([infoModel.verify[@"verify"] isEqualToString:@"3"]){
                self.leftTitle.text = NSLocalizedString(@"身份认证(未认证)", nil);
            }else if([infoModel.verify[@"verify"] isEqualToString:@"0"]){
                self.leftTitle.text = NSLocalizedString(@"身份认证(待审核)", nil);
            }else if([infoModel.verify[@"verify"] isEqualToString:@"2"]){
                self.leftTitle.text = NSLocalizedString(@"身份认证(被拒绝)", nil);
            }else if([infoModel.verify[@"verify"] isEqualToString:@"1"]){
                self.leftTitle.text = NSLocalizedString(@"身份认证(已认证)", nil);
            }
            [self changeVerifyColor];
            if([infoModel.verify[@"verify"] isEqualToString:@"1"]){
              self.rightTitle.hidden = YES;
            }else{
               self.rightTitle.hidden = NO;
               self.rightTitle.text = NSLocalizedString(@"去设置", nil);
            }
        }
            break;
        case 3:
        {
            self.leftTitle.textColor = HEX(@"999999", 1.0f);
            if([infoModel.is_account isEqualToString:@"0"]){
                self.leftTitle.text = NSLocalizedString(@"开户行设置(未设置)", nil);
                self.rightTitle.hidden = NO;
                self.rightTitle.text = NSLocalizedString(@"去设置", nil);
            }else if([infoModel.is_account isEqualToString:@"1"]){
                self.leftTitle.text = NSLocalizedString(@"开户行设置(已设置)", nil);
                self.rightTitle.hidden = YES;
            }
            [self changeBankColor];
        }
            break;
        case 4:
        {
            if([infoModel.from isEqualToString:@"paotui"]){
                self.leftTitle.text = NSLocalizedString(@"密码修改", nil);
                self.rightTitle.hidden = YES;
            }else{
                self.rightTitle.hidden = NO;
                if([infoModel.from isEqualToString:@"weixiu"]){
                    self.leftTitle.text = NSLocalizedString(@"维修技能", nil);
                    
                }else{
                    self.leftTitle.text = NSLocalizedString(@"家政技能", nil);
                }
                self.rightTitle.text = [NSString stringWithFormat:NSLocalizedString(@"%@项", nil),infoModel.tech_number];
            }
        }
            break;
        case 5:
        {
            self.rightTitle.hidden = YES;
            if([infoModel.from isEqualToString:@"paotui"]){
                self.leftTitle.text = NSLocalizedString(@"个人简介", nil);
            }else{
                self.leftTitle.text = NSLocalizedString(@"密码修改", nil);
            }
        }
            break;
        case 6:
        {
            self.rightTitle.hidden = YES;
             self.leftTitle.text = NSLocalizedString(@"个人简介", nil);
        }
            break;
        default:
            break;
    }
}

#pragma mark--===改变身份认证字体颜色
- (void)changeVerifyColor{
    
    NSRange verifyRange = [self.leftTitle.text rangeOfString:NSLocalizedString(@"身份认证", nil)];
    NSMutableAttributedString *verifyAttr = [[NSMutableAttributedString alloc] initWithString:self.leftTitle.text];
    [verifyAttr addAttributes:@{NSForegroundColorAttributeName:HEX(@"333333", 1.0f)} range:verifyRange];
    self.leftTitle.attributedText = verifyAttr;
}
#pragma mark---===改变开户行的字体颜色
- (void)changeBankColor{
    NSRange bankRange = [self.leftTitle.text rangeOfString:NSLocalizedString(@"开户行设置", nil)];
    NSMutableAttributedString *bankAttr = [[NSMutableAttributedString alloc] initWithString:self.leftTitle.text];
    [bankAttr addAttributes:@{NSForegroundColorAttributeName:HEX(@"333333", 1.0f)} range:bankRange];
    self.leftTitle.attributedText = bankAttr;
}
@end
