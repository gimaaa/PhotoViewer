//
//  KimBox. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "JJDataModel.h"

@interface JJMainScrollView : UIView

//展示 并添加数据
//models   全部模型数据
//selectImgViewIndex    第一个点开的图在第几个位置index
-(void)showAndSetModels:(NSArray <JJDataModel *> *)models selectImgViewIndex:(NSInteger)selectImgViewIndex;

//退出时最后点击的图角标
@property(nonatomic,copy)void(^exitComplate)(NSInteger lastSelectIndex);


@end
