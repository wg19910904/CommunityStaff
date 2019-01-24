//
//  JHPaotuiListModel.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/27.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHPaotuiListModel.h"

@implementation JHPaotuiListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@",key);
}


#pragma mark - 判断是否将商家和客户的姓名和电话隐藏
- (BOOL)shopInfoAllHidden{
    if ([self.type isEqualToString:@"buy"]) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)shopHidden{
    if (self.staff_id.integerValue > 0) {
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)clientHidden{
    if (self.staff_id.integerValue > 0) {
        return NO;
    }else{
        return YES;
    }
}
#pragma mark - 计算客户地址,商家地址,cell的高度
- (CGFloat)clientAddrH{
    if (!_clientAddrH) {
        NSString *clientAddr = [NSString stringWithFormat:@"%@%@",self.addr,self.house];
        _clientAddrH = getStrHeight(clientAddr, WIDTH-97, 14) + 5;
    }
    return _clientAddrH;
    
}

- (CGFloat)shopAddrH{
    if (!_shopAddrH) {
        NSString *shopAddr = [NSString stringWithFormat:@"%@%@",self.o_addr,self.o_house];
        _shopAddrH = getStrHeight(shopAddr, WIDTH-97, 14) + 5;
    }
    return _shopAddrH;
}

- (CGFloat)cellHeight{
    CGFloat temH = 40+42+44;
    if (!self.shopInfoAllHidden) {
        if (!self.shopHidden) {
            temH += 20;
        }
        temH += self.shopAddrH;
    }
    if (!self.clientHidden) {
        temH += 20;
    }
    temH += self.clientAddrH;
    return temH;
}
@end
