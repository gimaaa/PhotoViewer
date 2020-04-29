//
//  JJMainShowController.h
//  CZManage
//
//  Created by 金正国 on 2020/3/13.
//  Copyright © 2020 CYHC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJDataModel.h"
#import "JJPhotoOption.h"


@interface JJMainShowController : UIViewController

@property(nonatomic,strong)NSArray<JJDataModel *> *models;

@property(nonatomic,assign)NSInteger selectViewIndex;

//展示之前赋值
@property(nonatomic,strong)JJPhotoOption *option;

//删除的角标
@property(nonatomic,copy)void(^deleteComplate)(NSInteger deleteIndex,void(^affirm)(void));
@end


