//
//  KimBox. All rights reserved.
// czcy
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
#import "JJPhotoOption.h"


@interface JJPhotoManeger : NSObject


#pragma mark - ❤️俩核心功能

//展示之前赋值
@property(nonatomic,strong)JJPhotoOption *option;


//----------------------------------------------------view覆盖模式----------------------------------------------------------------------------------------

/**
 *  放大浏览图片
 *
 *  selectView:当前点击的imageView
 *  selectViewIndex:当前点击的imageView在数组中的index
 */
-(void)showPhotoViewerModels:(NSArray<JJDataModel *> *)models  superView:(UIView *)view selectView:(UIView *)selectView;
-(void)showPhotoViewerModels:(NSArray<JJDataModel *> *)models  superView:(UIView *)view selectViewIndex:(NSInteger)selectViewIndex;
//退出时最后正在看的图片位置
@property(nonatomic,copy)void(^exitComplate)(NSInteger lastSelectIndex);


//----------------------------------------------------控制器push模式---------------------------------------------------------------------------------------


//用控制器弹
-(void)showPhotoViewerModels:(NSArray<JJDataModel *> *)models controller:(UIViewController*)controller selectViewIndex:(NSInteger)selectViewIndex;
//查看器中点击了删除的角标(实现自己删数据源刷新)//不实现这个block 不会展示右上角删除按钮
@property(nonatomic,copy)void(^deleteComplate)(NSInteger deleteIndex,void(^affirm)(void));
//例子:
//    [UIAlertController alertWithTitle:@"确定删除吗?" message:nil viewController:weakSelf.currentVC confirmTitle:@"确定" confirmBlock:^{
//        //
//        [imageArr removeObjectAtIndex:deleteIndex];
//        UITableView *tableView = [weakSelf.currentVC valueForKey:@"tableView"];
//        if ([tableView isKindOfClass:[UITableView class]]) {
//            [tableView reloadData];
//        }
//        if (weakSelf.viewModel.storeImgCompleteBlock) {
//            weakSelf.viewModel.storeImgCompleteBlock();
//        }
//        //内部删除
//        if (affirm){
//            affirm();
//        }
//    } cancelTitle:@"取消" cancelBlock:^{
//    }];
//


@end
