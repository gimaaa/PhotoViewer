

#import "JJPhotoManeger.h"
#import "JJMainScrollView.h"


@interface JJPhotoManeger()



@end
@implementation JJPhotoManeger


-(void)showPhotoViewerModels:(NSArray<JJDataModel *> *)models selectViewIndex:(NSInteger)selectViewIndex{
    
    //主窗口
    JJMainScrollView *mainScrollView = [[JJMainScrollView alloc]init];
    mainScrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    mainScrollView.exitComplate = self.exitComplate;//block
    
    //主窗口底层View
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:mainScrollView];
    
    //如果index给错了防止崩溃当点击了第一个图
    if(selectViewIndex >= models.count){
        selectViewIndex = 0;
    }
    
    //展示图片们
    [mainScrollView showAndSetModels:models selectImgViewIndex:selectViewIndex];
}



-(void)showPhotoViewerModels:(NSArray<JJDataModel *> *)models  selectView:(UIView *)selectView{
    //寻找点击的图片时数组中的第几个
    NSInteger index = 0;
    for (NSInteger i = 0; i < models.count ; i++){
        JJDataModel *model = models[i];
        if(selectView == model.containerView){
            index = i;
            break;
        }
    }
    [self showPhotoViewerModels:models selectViewIndex:index];
}



@end
