

#import "JJPhotoManeger.h"
#import "JJMainScrollView.h"
#import "JJMainShowController.h"

@interface JJPhotoManeger()



@end
@implementation JJPhotoManeger

//用控制器弹
-(void)showPhotoViewerModels:(NSArray<JJDataModel *> *)models controller:(UIViewController*)controller selectViewIndex:(NSInteger)selectViewIndex{
    JJMainShowController *vc = [[JJMainShowController alloc]init];
    vc.models = models;
    vc.selectViewIndex = selectViewIndex;
    vc.deleteComplate = self.deleteComplate;
    vc.option = self.option;
    [controller.navigationController pushViewController:vc animated:YES];
}


-(void)showPhotoViewerModels:(NSArray<JJDataModel *> *)models  superView:(UIView *)view selectViewIndex:(NSInteger)selectViewIndex{
    
    //主窗口
    JJMainScrollView *mainScrollView = [[JJMainScrollView alloc]init];
    mainScrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    mainScrollView.exitComplate = self.exitComplate;//block
    mainScrollView.option = self.option;
    
    
    [view addSubview:mainScrollView];
    
    //如果index给错了防止崩溃当点击了第一个图
    if(selectViewIndex >= models.count){
        selectViewIndex = 0;
    }
    
    //展示图片们
    [mainScrollView showAndSetModels:models selectImgViewIndex:selectViewIndex controllerMode:NO];
    
  
}



-(void)showPhotoViewerModels:(NSArray<JJDataModel *> *)models superView:(UIView *)view  selectView:(UIView *)selectView{
    //寻找点击的图片时数组中的第几个
    NSInteger index = 0;
    for (NSInteger i = 0; i < models.count ; i++){
        JJDataModel *model = models[i];
        if(selectView == model.containerView){
            index = i;
            break;
        }
    }
    [self showPhotoViewerModels:models superView:view selectViewIndex:index];
}



@end
