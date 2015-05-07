//
//  JJMainScrollView.h
//  test
//
//  Created by KimBox on 15/4/28.
//  Copyright (c) 2015年 KimBox. All rights reserved.
//


typedef enum {
    JJLocalWithLocalPhotoViewer, //点击前是本地图,点击后也是本地图
    JJInternetWithInternetPhotoViewer //点击前是网络图,点击后也是网络图
}JJPhotoViewerType;

#import <UIKit/UIKit.h>



@protocol JJPhotoDelegate <NSObject>

@optional
//关闭PhotoViewer时调用并返回 (观看的最后一张图片的序号)
-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex;
@end


@interface JJMainScrollView : UIScrollView


//获取数据
-(void)setPhotoData:(NSArray *)photoArr Type:(JJPhotoViewerType)type;

/**代理*/
@property(nonatomic,weak)id<JJPhotoDelegate>  mainDelegate;

@end
