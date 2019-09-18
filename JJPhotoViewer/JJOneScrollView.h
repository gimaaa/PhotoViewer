//
//  KimBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJDataModel.h"

@interface JJOneScrollView : UIView

//数据
@property(nonatomic,strong)JJDataModel *model;

//开始展示:animation 为 YES 有展示动画 即(当前正在屏幕前)
-(void)showWithAnimation:(BOOL)animation completion:(void (^)(void))completion;

//从model数据中 加载网络图 或 加载本地图
-(void)starDownLoadImg;

//退出block
@property(nonatomic,copy)void(^backBlock)(BOOL animating);


@end
