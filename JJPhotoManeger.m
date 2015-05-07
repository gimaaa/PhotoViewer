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


+(instancetype)maneger
{
    JJPhotoManeger *mg = [[JJPhotoManeger alloc]init];
    return mg;
}



-(void)showLocalPhotoViewer:(NSArray *)imageViews selecView:(UIImageView *)selecView
{
    [self setUpPhotoData:imageViews selecView:selecView urlStrArr:nil type:JJLocalWithLocalPhotoViewer];
}



-(void)showNetworkPhotoViewer:(NSArray *)imageViews urlStrArr:(NSArray *)urlStrArr selecView:(UIImageView *)selecView
{
    
    [self setUpPhotoData:imageViews selecView:selecView urlStrArr:urlStrArr type:JJInternetWithInternetPhotoViewer];

}



-(void)setUpPhotoData:(NSArray *)imageViews  selecView:(UIImageView *)selecView urlStrArr:(NSArray *)urlStrArr  type:(JJPhotoViewerType)type
{
    
  
    NSUInteger selecImageindex  =[imageViews indexOfObject:selecView];
    
  
    NSMutableArray *photoModelArr = [NSMutableArray array];
    
    
    for (int i = 0; i < imageViews.count; i ++) {
        
        
        JJPhoto *photo =  [[JJPhoto alloc]init];
        
        
        UIImageView *imageView = imageViews[i];
        
       
        photo.imageView = imageView;
        
       
        if(type == JJInternetWithInternetPhotoViewer)
        {
          
            if(i >= urlStrArr.count || urlStrArr == nil )
            {
                photo.urlStr = @"";
            }else
            {
                photo.urlStr = urlStrArr[i];
            }
        }

        
        if(i == selecImageindex){
            photo.isSelecImageView = YES;
        }else{
            photo.isSelecImageView = NO;
        }
       
        [photoModelArr addObject:photo];
    }
    
   
    JJMainScrollView *mainScrollView = [[JJMainScrollView alloc]init];
    
    mainScrollView.mainDelegate = self.delegate;
   
    [mainScrollView setPhotoData:photoModelArr Type:type];
 
    [self show:mainScrollView];
    
}


-(void)show:(UIScrollView *)mainScrollView
{
   
    UIView *view =  [[UIView alloc]init];
    view.frame = [UIApplication sharedApplication].keyWindow.rootViewController.view.bounds;
    [view addSubview:mainScrollView];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:view];
}

@end
