//
//  JJPhoto.h
//  test
//
//  Created by KimBox on 15/4/28.
//  Copyright (c) 2015年 KimBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JJPhoto : NSObject


@property(nonatomic,strong)UIImageView *imageView;


@property(nonatomic,copy)NSString *urlStr;


@property(nonatomic,copy)NSString *holdImageStr;


@property(nonatomic,assign)BOOL isSelecImageView;


@end
