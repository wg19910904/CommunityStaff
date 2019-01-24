//
//  JHVerifyVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/6.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHVerifyVC.h"
#import <IQKeyboardManager.h>
#import "HttpTool.h"
#import "DisplayImageInView.h"
#import "UIImageView+WebCache.h"
@interface JHVerifyVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UITextField *_user;//姓名
    UITextField *_ID;//身份证号
    UIButton *_certainBnt;//确定按钮
    UILabel *_imgLabel;//参考照片or认证照片
    UIImageView *_addImg;//添加认证图图片
    UIImageView *_verifyImg;//认证图片
    UILabel *_yourLabel;//你的照片
    UIImagePickerController *_imagePicker;//照片选择器
    UIImage *_pickImg;//选择的那张照片
    DisplayImageInView *_displayView;//用于展示图片
    NSData *_data;//用于上传的图片数据
    UILabel *_verifyLabel;//认证标签
    UILabel *reasonL; //被拒绝原因label
}
@end

@implementation JHVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:NSLocalizedString(@"身份认证", nil)];
    [self initSubViews];
    [self handleData];
    [self createTableView];
}
#pragma mark======初始化子控件=======
- (void)initSubViews{
    _user = [[UITextField alloc] initWithFrame:FRAME(47, 0, WIDTH - 47, 44)];
    _user.delegate = self;
    _user.font = FONT(14);
    _user.textColor = HEX(@"333333", 1.0f);
    _user.placeholder = NSLocalizedString(@"请输入真实姓名", nil);
    _user.leftView = [[UIView alloc] initWithFrame:FRAME(0, 0, 10, 0)];
    _user.leftView.backgroundColor = [UIColor whiteColor];
    _user.leftViewMode = UITextFieldViewModeAlways;
    _ID = [[UITextField alloc] initWithFrame:FRAME(47, 0, WIDTH - 47, 44)];
    _ID.delegate = self;
    _ID.font = FONT(14);
    _ID.textColor = HEX(@"333333", 1.0f);
    _ID.placeholder = NSLocalizedString(@"请输入身份证号", nil);
    _ID.leftView = [[UIView alloc] initWithFrame:FRAME(0, 0, 10, 0)];
    _ID.leftView.backgroundColor = [UIColor whiteColor];
    _ID.leftViewMode = UITextFieldViewModeAlways;
    _certainBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _certainBnt.frame = FRAME(15, 0, WIDTH - 30, 44);
    _certainBnt.layer.cornerRadius = 4.0f;
    _certainBnt.clipsToBounds = YES;
    [_certainBnt setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [_certainBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_certainBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    _certainBnt.titleLabel.font = FONT(16);
    [_certainBnt addTarget:self action:@selector(clickCertainBnt) forControlEvents:UIControlEventTouchUpInside];
    _verifyLabel = [[UILabel alloc] initWithFrame:FRAME(15, 0, WIDTH - 30, 44)];
    _verifyLabel.font = FONT(18);
    _verifyLabel.textColor = HEX(@"cccccc", 1.0f);
    _verifyLabel.textAlignment = NSTextAlignmentCenter;
    _imgLabel = [[UILabel alloc] initWithFrame:FRAME((WIDTH / 2 - 60) / 2, 10, 60, 15)];
    _imgLabel.textColor = HEX(@"999999", 1.0f);
    _imgLabel.textAlignment = NSTextAlignmentCenter;
    _imgLabel.font = FONT(14);
    _yourLabel = [[UILabel alloc] initWithFrame:FRAME(WIDTH / 2 + (WIDTH / 2 - 60) / 2, 10, 60, 15)];
    _yourLabel.textColor = HEX(@"999999", 1.0f);
    _yourLabel.textAlignment = NSTextAlignmentCenter;
    _yourLabel.font = FONT(14);
    _yourLabel.text = NSLocalizedString(@"你的照片", nil);
    _verifyImg = [[UIImageView alloc] initWithFrame:FRAME(15, 0, (WIDTH - 45) / 2, 105)];
    _verifyImg.layer.cornerRadius = 4.0f;
    _verifyImg.layer.borderColor = LINE_COLOR.CGColor;
    _verifyImg.contentMode = UIViewContentModeScaleToFill;
    _verifyImg.clipsToBounds = YES;
    UITapGestureRecognizer *verifyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleVerifyImg)];
    [_verifyImg addGestureRecognizer:verifyTap];
    _addImg = [[UIImageView alloc] initWithFrame:FRAME((WIDTH - 45) / 2 + 30, 0, (WIDTH - 45) / 2, 105)];
    _addImg.image = IMAGE(@"zl_idcard_add");
    _addImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImg)];
    [_addImg addGestureRecognizer:addTap];
    _imagePicker = [[UIImagePickerController alloc] init];
    //添加被拒原因
    reasonL = [[UILabel alloc] initWithFrame:FRAME(15, 0, WIDTH - 30, 150)];
    reasonL.textColor = HEX(@"F96720", 1.0);
    reasonL.font = FONT(16);
    if (self.reason.length && [_verifyStatus isEqualToString:@"2"]) {
        reasonL.text = [NSLocalizedString(@"拒绝原因:  ", nil) stringByAppendingString:self.reason];
    }
}
#pragma mark=====进行数据操作======
- (void)handleData{
    
    if([_verifyStatus isEqualToString:@"3"]){
       //未认证
        _user.userInteractionEnabled = YES;
        _ID.userInteractionEnabled = YES;
        _addImg.userInteractionEnabled = YES;
        _verifyLabel.hidden = YES;
        _certainBnt.userInteractionEnabled = YES;
         _imgLabel.text = NSLocalizedString(@"参考照片", nil);
        [_certainBnt setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
         _verifyImg.userInteractionEnabled = YES;
        [_verifyImg sd_setImageWithURL:[NSURL URLWithString:_img] placeholderImage:IMAGE(@"zl_idcard")];
//         _verifyImg.image = IMAGE(@"zl_idcard");
    }else if([_verifyStatus isEqualToString:@"0"]){
        
       //待审核
        _user.text = self.userName;
        _ID.text = self.userId;
        [_verifyImg sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:self.img]] placeholderImage:IMAGE(@"zl_idcard")];
        _user.userInteractionEnabled = NO;
        _ID.userInteractionEnabled = NO;
        _addImg.userInteractionEnabled = NO;
        _certainBnt.userInteractionEnabled = NO;
        _certainBnt.hidden = YES;
        _verifyLabel.hidden = NO;
        _verifyLabel.text = NSLocalizedString(@"正在审核,请耐心等待", nil);
         _imgLabel.text = NSLocalizedString(@"认证照片", nil);
         _verifyImg.userInteractionEnabled = NO;
    }else if([_verifyStatus isEqualToString:@"1"]){
        //通过认证
        _user.text = self.userName;
        _ID.text = self.userId;
        [_verifyImg sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:self.img]] placeholderImage:IMAGE(@"zl_idcard")];
        _user.userInteractionEnabled = NO;
        _ID.userInteractionEnabled = NO;
        _addImg.userInteractionEnabled = NO;
        _certainBnt.userInteractionEnabled = NO;
        _certainBnt.hidden = YES;
        _verifyLabel.hidden = NO;
        _verifyLabel.text = NSLocalizedString(@"恭喜你,认证成功", nil);
        _imgLabel.text = NSLocalizedString(@"认证照片", nil);
         _verifyImg.userInteractionEnabled = NO;
    }else if ([_verifyStatus isEqualToString:@"2"]){
        //被拒绝
        _user.text = self.userName;
        _ID.text = self.userId;
        [_verifyImg sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:self.img]] placeholderImage:IMAGE(@"zl_idcard") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
             _pickImg = _verifyImg.image;
             [self handleImg];
        }];
        _user.userInteractionEnabled = YES;
        _ID.userInteractionEnabled = YES;
        _addImg.userInteractionEnabled = YES;
        _verifyLabel.hidden = YES;
        _certainBnt.userInteractionEnabled = YES;
        _certainBnt.hidden = NO;
        _verifyLabel.hidden = YES;
        _imgLabel.text = NSLocalizedString(@"认证照片", nil);
         _verifyImg.userInteractionEnabled = YES;
        [_certainBnt setTitle:NSLocalizedString(@"重新认证", nil) forState:UIControlStateNormal];
    }
    
}
#pragma mark======对认证图片进行操作=======
- (void)handleVerifyImg{
    if([_imgLabel.text isEqualToString:NSLocalizedString(@"认证照片", nil)]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消了");
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"查看原图", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(_displayView == nil)
            {
                _displayView = [[DisplayImageInView alloc] init];
                [ _displayView showInViewWithImageArray:@[_verifyImg.image] withIndex:1 withBlock:^{
                    [_displayView removeFromSuperview];
                    _displayView = nil;
                }];
            }
        }];
        UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"删除图片", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _verifyImg.image = IMAGE(@"zl_idcard");
            _imgLabel.text = NSLocalizedString(@"参考照片", nil);
            NSArray *indexPath = @[[NSIndexPath indexPathForRow:1 inSection:1]];
            [_tableView reloadRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationNone];
        }];
        [alertController addAction:deleteAction];
        [alertController addAction:archiveAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        
    }
}
#pragma mark====确定按钮点击事件=====
- (void)clickCertainBnt{
    NSLog(@"确定");
    if(_user.text.length == 0){
        [self showAlertViewWithTitle:NSLocalizedString(@"请输入真实姓名", nil)];
    }else if (_ID.text.length == 0){
        [self showAlertViewWithTitle:NSLocalizedString(@"请输入身份证号", nil)];
    }else if(_data == nil){
        [self showAlertViewWithTitle:NSLocalizedString(@"请选择认证图片", nil)];
    }else{
        SHOW_HUD
        NSDictionary *dic = @{@"id_name":_user.text,@"id_number":_ID.text};
        NSDictionary *dataDic = @{@"photo":_data};
        [HttpTool postWithAPI:@"staff/account/verify"
                          params:dic
                     fromDataDic:dataDic
                         success:^(id json) {
                             if([json[@"error"] isEqualToString:@"0"]){
                                 HIDE_HUD
                                 _user.userInteractionEnabled = NO;
                                 _ID.userInteractionEnabled = NO;
                                 _addImg.userInteractionEnabled = NO;
                                 [_certainBnt setBackgroundColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
                                 _certainBnt.userInteractionEnabled = NO;
                                 _certainBnt.hidden = YES;
                                 _verifyLabel.hidden = NO;
                                 _verifyLabel.text = NSLocalizedString(@"提交认证资料成功,请耐心等待审核", nil);
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"verify" object:nil];
                                 [self.navigationController popViewControllerAnimated:YES];
                             }else{
                                 HIDE_HUD
                                 [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedString(@"提交认证资料失败,原因:%@", nil),json[@"message"]]];
                             }
                         } failure:^(NSError *error) {
                             HIDE_HUD
                             NSLog(@"error%@",error.localizedDescription);
                             [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
                         }];
        
    }
}
#pragma mark====选择添加照片========
- (void)addImg{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    UIAlertAction *man = [UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self imageFromCamera];
    }];
    UIAlertAction *woman = [UIAlertAction actionWithTitle:NSLocalizedString(@"从手机相册选取", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self imageFromAlbum];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:man];
    [alertController addAction:woman];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark=========相册中选择=========
- (void)imageFromAlbum{
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}
#pragma mark=========打开相机=========
- (void)imageFromCamera{
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}
#pragma  mark - 这是UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    NSLog(@"哈哈");
}
#pragma  mark=======选择照片================
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (picker.allowsEditing) {
        _pickImg = [info objectForKey:UIImagePickerControllerEditedImage];
        
    }else{
        _pickImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    _addImg.image = _pickImg;
    _imgLabel.text = NSLocalizedString(@"认证照片", nil);
    [self handleImg];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark===选择图片的处理======
- (void)handleImg{
    NSArray *indeth = @[[NSIndexPath indexPathForRow:1 inSection:1],[NSIndexPath indexPathForRow:0 inSection:1]];
    [_tableView reloadRowsAtIndexPaths:indeth withRowAnimation: UITableViewRowAnimationNone];
    _pickImg = [self scaleFromImage:_pickImg scaledToSize:CGSizeMake(180, 180)];
    _data = UIImagePNGRepresentation(_pickImg);
}
#pragma mark=====压缩照片尺寸======
- (UIImage*)scaleFromImage:(UIImage*)img scaledToSize:(CGSize)newSize{
    CGSize imageSize = img.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width <= newSize.width && height <= newSize.height){
        return img;
    }
    if (width == 0 || height == 0){
        return img;
    }
    CGFloat widthFactor = newSize.width / width;
    CGFloat heightFactor = newSize.height / height;
    CGFloat scaleFactor = (widthFactor<heightFactor?widthFactor:heightFactor);
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth,scaledHeight);
    UIGraphicsBeginImageContext(targetSize);
    [img drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark===============点击取消调用========
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark====创建表视图======
- (void)createTableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, _tableView.bounds.size.width, _tableView.bounds.size.height)];
        view.backgroundColor = BACK_COLOR;
        _tableView.backgroundView = view;
        [self.view addSubview:_tableView];
    }else{
        [_tableView reloadData];
    }

}
#pragma mark=====UITableViewDelegate====
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if(section == 2)
      return 2;
    else
        return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        if(indexPath.row == 0)
            return 35;
        else
            return 115;
    }else if (indexPath.section == 2 && indexPath.row == 1){
        return 150;
    }else
        return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0)
        return 40;
    else if(section == 1)
        return 20;
    else
        return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME(15, 13.5, 17, 17)];
                img.image = IMAGE(@"zl_name");
                UIView *thread = [[UIView alloc] initWithFrame:FRAME(46.5, 11, 0.5, 20)];
                thread.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread];
                UIView *bottomLine = [[UIView alloc] initWithFrame:FRAME(0, 43.5, WIDTH, 0.5)];
                bottomLine.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:bottomLine];
                [cell.contentView addSubview:img];
                [cell.contentView addSubview:_user];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                return cell;
            }
                break;
            case 1:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME(15, 13.5, 17, 17)];
                img.image = IMAGE(@"zl_card");
                UIView *thread = [[UIView alloc] initWithFrame:FRAME(46.5, 11, 0.5, 20)];
                thread.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread];
                UIView *bottomLine = [[UIView alloc] initWithFrame:FRAME(0, 43.5, WIDTH, 0.5)];
                bottomLine.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:bottomLine];
                [cell.contentView addSubview:img];
                [cell.contentView addSubview:_ID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                return cell;
            }
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                UIView *thread1 = [[UIView alloc] initWithFrame:FRAME(0, 0,WIDTH, 0.5)];
                thread1.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread1];
                [cell.contentView addSubview:_imgLabel];
                [cell.contentView addSubview:_yourLabel];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            case 1:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                UIView *thread2 = [[UIView alloc] initWithFrame:FRAME(0,114.5,WIDTH, 0.5)];
                thread2.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread2];
                [cell.contentView addSubview:_verifyImg];
                [cell.contentView addSubview:_addImg];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            default:
                break;
        }
        
    }else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell.contentView addSubview:_verifyLabel];
            [cell.contentView addSubview:_certainBnt];
            cell.contentView.backgroundColor = BACK_COLOR;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell.contentView addSubview:reasonL];
            cell.contentView.backgroundColor = BACK_COLOR;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0){
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 40)];
        view.backgroundColor = BACK_COLOR;
        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(15, 15, WIDTH - 15, 15)];
        label.font = FONT(12);
        label.textColor = HEX(@"333333", 1.0f);
        NSString *str = NSLocalizedString(@"拍摄身份证正面照(请保证照片中文清晰)", nil);
        NSRange range = [str rangeOfString:NSLocalizedString(@"(请保证照片中文清晰)", nil)];
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:str];
        [attributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"00b7ee", 1.0f)} range:range];
        label.attributedText = attributed;
        [view addSubview:label];
        return view;
    }
    return nil;
}
#pragma mark=======UITextFieldDelegate=========
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
#pragma mark======scrollViewDelegate==========
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    if(manager.enable){
        
    }else{
        [self.view endEditing: YES];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
}
@end
