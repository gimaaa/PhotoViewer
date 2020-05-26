//
//  KimBox. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "JJDataModel.h"
#import "JJPhotoOption.h"

@interface JJMainScrollView : UIView

//展示之前赋值
@property(nonatomic,strong)JJPhotoOption *option;

//展示 并添加数据
//models   全部模型数据
//selectImgViewIndex    第一个点开的图在第几个位置index
-(void)showAndSetModels:(NSArray <JJDataModel *> *)models selectImgViewIndex:(NSInteger)selectImgViewIndex controllerMode:(BOOL)controllerMode;


//点击的
@property(nonatomic,copy)void(^clickBlock)(NSInteger Index);
//点击的
@property(nonatomic,copy)void(^pageChangeBlock)(NSInteger currentIndex);


//退出时最后点击的图角标
@property(nonatomic,copy)void(^exitComplate)(NSInteger lastSelectIndex);

@end
