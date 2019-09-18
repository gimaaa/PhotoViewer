//
//  KimBox. All rights reserved.
//
//  兼容性强
//
//  本代码加载网络图片用的是SDWebimage框架,如需更换请前往改代码
//  [JJOneScrollView starDownLoadImg]
//  [JJOneScrollView dealloc]
//
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JJDataModel.h"
#import "JJMainScrollView.h"



@interface JJPhotoManeger : NSObject


#pragma mark - ❤️俩核心功能


/**
 *  放大浏览图片
 *
 *  selectView:当前点击的imageView
 *  selectViewIndex:当前点击的imageView在数组中的index
 */
-(void)showPhotoViewerModels:(NSArray<JJDataModel *> *)models  selectView:(UIView *)selectView;
-(void)showPhotoViewerModels:(NSArray<JJDataModel *> *)models  selectViewIndex:(NSInteger)selectViewIndex;


//退出时最后点击的图角标
@property(nonatomic,copy)void(^exitComplate)(NSInteger lastSelectIndex);

@end
