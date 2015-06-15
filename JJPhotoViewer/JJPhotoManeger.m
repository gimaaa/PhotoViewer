//
//  JJPhotoManeger.m
//  test
//
//  Created by KimBox on 15/4/28.
//  Copyright (c) 2015年 KimBox. All rights reserved.
//

#import "JJPhotoManeger.h"
//model
#import "JJPhoto.h"


@implementation JJPhotoManeger

/**
 *  创建
 */
+(instancetype)maneger
{
    JJPhotoManeger *mg = [[JJPhotoManeger alloc]init];
    return mg;
}


/**
 *  本地图片放大浏览
 */
-(void)showLocalPhotoViewer:(NSArray *)imageViews selecView:(UIImageView *)selecView
{
    [self setUpPhotoData:imageViews selecView:selecView urlStrArr:nil type:JJLocalWithLocalPhotoViewer];
}


/**
 * 点击网络下载图片浏览
 */
-(void)showNetworkPhotoViewer:(NSArray *)imageViews urlStrArr:(NSArray *)urlStrArr selecView:(UIImageView *)selecView
{
    
    [self setUpPhotoData:imageViews selecView:selecView urlStrArr:urlStrArr type:JJInternetWithInternetPhotoViewer];
}



//拿到数据设置整体页面
-(void)setUpPhotoData:(NSArray *)imageViews  selecView:(UIImageView *)selecView urlStrArr:(NSArray *)urlStrArr  type:(JJPhotoViewerType)type
{
    
    //点击的是第几个图片
    NSUInteger selecImageindex  =[imageViews indexOfObject:selecView];
    
    //创建模型数组
    NSMutableArray *photoModelArr = [NSMutableArray array];
    
    
    for (int i = 0; i < imageViews.count; i ++) {
        
        //创建模型
        JJPhoto *photo =  [[JJPhoto alloc]init];
        
        //取出imageView
        UIImageView *imageView = imageViews[i];
        
        //包装模型
        photo.imageView = imageView;
        
        //如果是网络看图模式
        if(type == JJInternetWithInternetPhotoViewer)
        {
            //包装网络地址
            if(i >= urlStrArr.count || urlStrArr == nil )
            {
                photo.urlStr = @"";
            }else
            {
                photo.urlStr = urlStrArr[i];
            }
        }

        //包装信息:这个imageView是不是点击进来的时候的imageView
        if(i == selecImageindex){
            photo.isSelecImageView = YES;
        }else{
            photo.isSelecImageView = NO;
        }
        
        //放入模型数组
        [photoModelArr addObject:photo];
    }
    
    //传模型包给主滚动窗
    JJMainScrollView *mainScrollView = [[JJMainScrollView alloc]init];
    //传递代理
    mainScrollView.mainDelegate = self.delegate;
    //给数据 type:然后说明是本地加载/还是网络加载  
    [mainScrollView setPhotoData:photoModelArr Type:type];
    //展示
    [self show:mainScrollView];
    
}


//展示
-(void)show:(UIScrollView *)mainScrollView
{
    //创建原始的底层View一个
    UIView *view =  [[UIView alloc]init];
    view.frame = [UIApplication sharedApplication].keyWindow.rootViewController.view.bounds;
    [view addSubview:mainScrollView];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:view];
    
}





@end
