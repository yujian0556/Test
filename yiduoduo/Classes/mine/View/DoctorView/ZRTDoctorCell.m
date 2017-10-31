//
//  ZRTDoctorCell.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/2.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTDoctorCell.h"

#import "UIImageView+WebCache.h"
#import "Interface.h"

#define KfengeColor [UIColor colorWithRed:221/256.0 green:221/256.0 blue:221/256.0 alpha:1]
#define KIDColor [UIColor colorWithRed:175/256.0 green:175/256.0 blue:175/256.0 alpha:1]



@interface ZRTDoctorCell ()


@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *IDLabel;

@property (nonatomic,strong) UIButton *send;


@property (nonatomic,assign) CGFloat cellH;

@property (nonatomic,assign) CGFloat font;

@end


@implementation ZRTDoctorCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"DoctorCell";
    
    ZRTDoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[ZRTDoctorCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
        
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    
    
    return cell;
}





-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self OSD];
        
        [self setAllView];
        
    }
    
    return self;
}



-(void)OSD
{
    if (KScreenHeight == 480) {  // 4s
        
        _cellH = 60;
        _font = 12;
        
    }else if (KScreenHeight == 568){  // 5s
        _cellH = 70;
        _font = 14;
        
    }else if (KScreenHeight == 667){  // 6
        
        _cellH = 80;
        _font = 16;
        
    }else{  // 6p
        
        _cellH = 80;
        _font = 18;
    }
    
}




-(void)setAllView{
    
    CGFloat margin = 10;
    
    CGFloat titleH = 30;
    
    CGFloat titleW = 100;
    
    //  头像
    
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(margin*2, margin, self.cellH - margin*2, self.cellH - margin*2)];
    
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageInterface,self.model.ImgUrl]] placeholderImage:[UIImage imageNamed:@"mine_icon_face_default"]];
    
    [self.contentView addSubview:self.iconView];
    
    
    
    // 姓名
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame)+margin, CGRectGetMinY(self.iconView.frame), titleW, titleH)];
    
    self.nameLabel.text = self.model.NickName;
    
    self.nameLabel.font = [UIFont systemFontOfSize:self.font+2];
    
    
    [self.nameLabel sizeToFit];
    
    
    CGFloat nameH = self.nameLabel.height;
    CGFloat nameW = self.nameLabel.width;
    
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.iconView.frame)+margin, CGRectGetMinY(self.iconView.frame)+5, nameW, nameH);
    
    
    
    [self.contentView addSubview:self.nameLabel];
    
    
    
    // 身份标签
    
    
    self.IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame)+margin, CGRectGetMaxY(self.iconView.frame)-titleH, titleW+50, titleH)];
    
    self.IDLabel.text = [NSString stringWithFormat:@"%@%@医生",self.model.SectionOffice,self.model.Professional];
    
    self.IDLabel.font = [UIFont systemFontOfSize:self.font ];
    
    self.IDLabel.textColor = KIDColor;
    
    
    [self.IDLabel sizeToFit];
    
    
    CGFloat IDH = self.IDLabel.height;
    CGFloat IDW = self.IDLabel.width;
    
    
    self.IDLabel.frame = CGRectMake(CGRectGetMaxX(self.iconView.frame)+margin, CGRectGetMaxY(self.iconView.frame)-IDH-5, IDW, IDH);
    
    
    [self.contentView addSubview:self.IDLabel];
    
    
    
    // 发消息按钮
    
    
    self.send = [[UIButton alloc] init];
    
    [self.send setBackgroundImage:[UIImage imageNamed:@"mess"] forState:UIControlStateNormal];
    
   // [self.send setTitle:@"发消息" forState:UIControlStateNormal];
    
    [self.send setTitleColor: KcompiledColor forState:UIControlStateNormal];
    
    self.send.titleLabel.font = [UIFont systemFontOfSize:self.font];

    
    [self.send sizeToFit];
    
    
    CGFloat sendW ;
    CGFloat sendH ;
    
    if (KScreenHeight == 480) {  // 4s
        
        sendW = self.send.width *0.9;
        sendH = self.send.height *0.9;
        
        
    }else if (KScreenHeight == 568){  // 5s
        
        sendW = self.send.width ;
        sendH = self.send.height ;
        
        
    }else if (KScreenHeight == 667){  // 6
        
        
        sendW = self.send.width ;
        sendH = self.send.height ;
        
        
    }else{  // 6p
        
        sendW = self.send.width *1.3;
        sendH = self.send.height *1.5;
        
        
    }

    
    
    self.send.frame = CGRectMake(KScreenWidth - margin - sendW, (self.cellH - sendH)*0.5, sendW, sendH);
    
    
    [self.send addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
   // NSLog(@"send %@",NSStringFromCGRect(self.send.frame));
    
    [self.contentView addSubview:self.send];
    
    
    
    //  分割线
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.cellH - 1, KScreenWidth, 1)];
    
    view.backgroundColor = KfengeColor;
   
    view.alpha = 0.5;
    
    [self.contentView addSubview:view];
    
 //   NSLog(@"view %@",NSStringFromCGRect(view.frame));
    
}




-(void)sendMessage
{
   
    
    
    
    if ([self.delegete respondsToSelector:@selector(lineDoctor:)]) {
        
        
        [self.delegete lineDoctor:self.model];
    }
    

}




@end
