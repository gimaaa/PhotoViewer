//
//   111KimBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JJDataModel : NSObject

//此图片所在的的容器view  , 如不填写: 将没有 (展示与回缩动画)
@property(nonatomic,strong)UIView *containerView;

//图片加载完前显示的占位图  ,   如不填写: 默认采用containerView 的内容(如 imageview的图  button的图或背景)  , 都没有就是黑色
@property(nonatomic,strong)UIImage *holdImg;


//-----------------------加载显示图片来源-------------------------------------
//点击图片后 网路加载图   第一优先级 (imgUrl加载失败 或为空 会去加载 localImgNamed)
@property(nonatomic,copy)NSString *imgUrl;

//点击图片后 要显示的图的本地图  第二优先级
@property(nonatomic,copy)NSString *localImgNamed;
//------------------------------------------------------------





//
//其他属性你可以自己加,自己去改源码 因为备注很详细 所以好改
//


@end

