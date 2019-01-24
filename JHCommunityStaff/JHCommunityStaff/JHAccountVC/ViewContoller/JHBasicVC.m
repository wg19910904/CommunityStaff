//
//  JHBasicVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/6.
//  Copyright © 2016年 jianghu2. All rights reserved.
//基本资料

#import "JHBasicVC.h"
#import "JHChangeMobileVC.h"
#import "JHChangeNameVC.h"
#import "HttpTool.h"
#import "UIImageView+WebCache.h"
@interface JHBasicVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIImageView *_iconImg;//头像
    UILabel *_nameLabel;//姓名
    UILabel *_mobileLabel;//电话
    UIImagePickerController *_imagePicker;//照片选择器
    UIImage *_pickImg;//选择的那张照片
}
@end

@implementation JHBasicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:NSLocalizedString(@"基本资料", nil)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChangeName:) name:@"changeName" object:nil];//修改姓名通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMobile:) name:@"changeMobile" object:nil];//更换电话成功
    [self initSubViews];
    [self createTableView];
}
#pragma mark======修改姓名成功=======
- (void)updateChangeName:(NSNotification *)noti{
   
    _nameLabel.text = noti.userInfo[@"name"];
    //[self requeNameStatus];
}
#pragma mark===更换电话号码成功=====
- (void)updateMobile:(NSNotification *)noti{
    NSMutableString *str = [[NSMutableString alloc] initWithString:noti.userInfo[@"mobile"]];
    [str replaceCharactersInRange:NSMakeRange(str.length-8, 4) withString:@"****"];
    _mobileLabel.text = str;
}
#pragma mark======初始化子控件=====
- (void)initSubViews{
    _iconImg = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 72, 15, 40, 40)];
    _iconImg.layer.cornerRadius = _iconImg.frame.size.width / 2;
    _iconImg.contentMode = UIViewContentModeScaleAspectFill;
    _iconImg.clipsToBounds = YES;
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:_face]] placeholderImage:IMAGE(@"sy_head")];
    _nameLabel = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 150 - 32, 14.5, 150, 15)];
    _nameLabel.font = FONT(14);
    _nameLabel.textColor = HEX(@"999999", 1.0f);
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.text = _userName;
    _mobileLabel = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 150 - 32, 14.5, 150, 15)];
    _mobileLabel.textColor = HEX(@"999999", 1.0f);
    _mobileLabel.font = FONT(14);
    NSMutableString *str = [[NSMutableString alloc] initWithString:_mobile];
    [str replaceCharactersInRange:NSMakeRange(str.length-8, 4) withString:@"****"];
    _mobileLabel.text = str;
    _mobileLabel.textAlignment = NSTextAlignmentRight;
    _imagePicker = [[UIImagePickerController alloc] init];
}
//#pragma mark====是否能够修改姓名====
//- (void)requeNameStatus{
//    SHOW_HUD
//    [HttpTool postWithAPI:@"staff/account/is_name" withParams:@{} success:^(id json) {
//        NSLog(@"json%@",json);
//        if([json[@"error"] isEqualToString:@"0"]){
//            HIDE_HUD
//            _name_status = json[@"data"][@"name_status"];
//            [self createTableView];
//        }else{
//            HIDE_HUD
//            [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedString(@"数据请求失败,原因:%@", nil),json[@"message"]]];
//        }
//    } failure:^(NSError *error) {
//        HIDE_HUD
//        NSLog(@"error%@",error.localizedDescription);
//        [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
//    }];
//}
#pragma mark======创建表视图==========
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
#pragma mark=====UITableViewDElegate=======
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)
        return 2;
    else
        return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            return 70;
        }else{
            return 44;
        }
    }else
        return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0)
        return 10;
    else
        return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                [cell.contentView addSubview:_iconImg];
                UILabel *title = [[UILabel alloc] initWithFrame:FRAME(15, 29, 100, 15)];
                title.font = FONT(14);
                title.textColor = HEX(@"333333", 1.0f);
                title.text = NSLocalizedString(@"头像", nil);
                [cell.contentView addSubview:title];
                UIImageView *dirImg = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 22, 29, 7, 12)];
                dirImg.image = IMAGE(@"arrow_right");
                [cell.contentView addSubview:dirImg];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            case 1:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                [cell.contentView addSubview:_nameLabel];
                UILabel *title = [[UILabel alloc] initWithFrame:FRAME(15, 14.5, 100, 15)];
                title.font = FONT(14);
                title.textColor = HEX(@"333333", 1.0f);
                title.text = NSLocalizedString(@"姓名", nil);
                [cell.contentView addSubview:title];
                UIImageView *dirImg = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 22, 14.5, 7, 12)];
                dirImg.image = IMAGE(@"arrow_right");
                [cell.contentView addSubview:dirImg];
                UIView *thread1 = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
                thread1.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread1];
                UIView *thread2 = [[UIView alloc] initWithFrame:FRAME(0, 43.5, WIDTH, 0.5)];
                thread2.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread2];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;

            }
                break;
                
            default:
                break;
        }
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UILabel *title = [[UILabel alloc] initWithFrame:FRAME(15, 14.5, 100, 15)];
        title.font = FONT(14);
        title.textColor = HEX(@"333333", 1.0f);
        title.text = NSLocalizedString(@"手机号", nil);
        [cell.contentView addSubview:title];
        [cell.contentView addSubview:_mobileLabel];
        UIImageView *dirImg = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 22, 14.5, 7, 12)];
        dirImg.image = IMAGE(@"arrow_right");
        [cell.contentView addSubview:dirImg];
        UILabel *thread1 = [[UILabel alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        thread1.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:thread1];
        UIView *thread2 = [[UIView alloc] initWithFrame:FRAME(0, 43.5, WIDTH, 0.5)];
        thread2.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:thread2];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            [self selectImg];
        }else{
            if([_verify isEqualToString:@"1"]){
                [self showAlertViewWithTitle:NSLocalizedString(@"身份认证成功无法修改姓名", nil)];
            }else{
                
                JHChangeNameVC *name = [[JHChangeNameVC alloc] init];
                [self.navigationController pushViewController:name animated:YES];
            }
        }
    }else{
        JHChangeMobileVC *mobile = [[JHChangeMobileVC alloc] init];
        mobile.mobile = _mobile;
        [mobile setMyBlock:^(NSString * newMobile) {
            _mobile = newMobile;
        }];
        [self.navigationController pushViewController:mobile animated:YES];
    }
}
#pragma mark======选择照片======
- (void)selectImg{
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
    _imagePicker.navigationBar.tintColor = THEME_COLOR;
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
    _pickImg = [self scaleFromImage:_pickImg scaledToSize:CGSizeMake(180, 180)];
    NSData * data = UIImagePNGRepresentation(_pickImg);
    SHOW_HUD
    NSDictionary * dic = @{@"face":data};
    [HttpTool postWithAPI:@"staff/account/update_face" params:@{} fromDataDic:dic success:^(id json) {
        NSLog(@"json%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            _iconImg.image = _pickImg;
            NSArray *indeth = @[[NSIndexPath indexPathForRow:0 inSection:0]];
            [_tableView reloadRowsAtIndexPaths:indeth withRowAnimation: UITableViewRowAnimationNone];
            [self showAlertViewWithTitle:NSLocalizedString(@"上传头像成功", nil)];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImg" object:nil];
            HIDE_HUD
        }
        else
        {
            HIDE_HUD
            [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedString(@"上传头像失败,原因:%@", nil),json[@"message"]]];
        }
        
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"%@",error.localizedDescription);
        [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeName" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeMobile" object:nil];
}
@end
