
#import "JJMainScrollView.h"
#import "JJDataModel.h"
#import "JJOneScrollView.h"
#import "UIImageView+WebCache.h"

#define Gap 10   //俩照片间黑色间距的一半

@interface JJMainScrollView()<UIScrollViewDelegate>


//存放了所有 单个滚动器
@property(nonatomic,strong)NSMutableArray *oneScrolArr;

//滚动
@property(nonatomic,strong)UIScrollView *mainScroll;

//底部小圆点
@property(nonatomic,strong)UIPageControl *pageCt;

//保存按钮
@property(nonatomic,strong)UIButton *saveBtn;

//数据
@property(nonatomic,strong)NSArray<JJDataModel *>*models;

//保存图片用的菊花
@property(nonatomic,strong)UIActivityIndicatorView *indicator;
@end


@implementation JJMainScrollView

-(void)layoutSubviews{
    [super layoutSubviews];
    self.mainScroll.frame = CGRectMake(-Gap, 0,self.frame.size.width + Gap + Gap,self.frame.size.height);
    self.pageCt.bounds = CGRectMake(0, 0, self.frame.size.width, 35);
    self.pageCt.center = CGPointMake(self.frame.size.width/2, self.frame.size.height -   self.pageCt.bounds.size.height/2);
    self.saveBtn.frame = CGRectMake(self.frame.size.width - 60, self.frame.size.height - 60, 36, 23);
}

//存放了所有 单个滚动器数组懒加载
-(NSMutableArray *)oneScrolArr{
    if(_oneScrolArr == nil){
        _oneScrolArr = [NSMutableArray array];
    }
    return  _oneScrolArr;
}

#pragma mark - 自己的属性设置一下
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        //主滚动
        UIScrollView *mainScroll = [[UIScrollView alloc]init];
        mainScroll.backgroundColor = [UIColor blackColor];
        mainScroll.pagingEnabled = YES;
        mainScroll.showsHorizontalScrollIndicator = NO;
        [self addSubview:mainScroll];
        mainScroll.delegate = self;
        self.mainScroll = mainScroll;
        
        
        //pageCt
        UIPageControl *pageCt = [[UIPageControl alloc]init];
        pageCt.currentPageIndicatorTintColor = [UIColor whiteColor];
        pageCt.pageIndicatorTintColor = [UIColor colorWithRed:(66.0)/255.0 green:(66.0)/255.0 blue:(66.0)/255.0 alpha:1.0];
        [self addSubview:pageCt];
        self.pageCt = pageCt;
        
        
        //保存按钮
        UIButton *saveButton = [[UIButton alloc] init];
        saveButton.layer.borderWidth = 0.5;
        saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
        self.saveBtn = saveButton;
        [self addSubview:saveButton];
    }
    return self;
}

- (void)saveImage{
    NSInteger currentIndex = self.mainScroll.contentOffset.x / self.mainScroll.bounds.size.width;
    JJOneScrollView *selfScroll =  self.oneScrolArr[currentIndex];
    
    if([selfScroll getComplateIMG] == nil){
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
        label.layer.cornerRadius = 5;
        label.clipsToBounds = YES;
        label.bounds = CGRectMake(0, 0, 160, 30);
        label.center = self.center;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:13];
        [[UIApplication sharedApplication].keyWindow addSubview:label];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
        label.text = @"请图片加载完成后再试";
        [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
        return;
    }
     self.saveBtn.hidden = YES;
    UIImageView *currentImageView = [[UIImageView alloc]initWithImage:[selfScroll getComplateIMG]];
    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    self.indicator = indicator;
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [self.indicator removeFromSuperview];
    self.saveBtn.hidden = NO;
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:13];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = @"保存失败";
    }   else {
        label.text = @"保存成功";
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.6];
}

-(void)showAndSetModels:(NSArray<JJDataModel *> *)models selectImgViewIndex:(NSInteger)selectImgViewIndex controllerMode:(BOOL)controllerMode{
    //qingkong
    [self.mainScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.oneScrolArr = nil;
    
    //页码
    self.pageCt.hidden = controllerMode;
    //保存按钮
    self.saveBtn.hidden = controllerMode;
 
    CGFloat mainScrollW = self.frame.size.width + 2 * Gap;
    //设置可滚动范围
    self.mainScroll.contentSize =  CGSizeMake(models.count * mainScrollW, 0);
    
    //设置首个展示页面
    self.mainScroll.contentOffset = CGPointMake(selectImgViewIndex * mainScrollW, 0);
    
    //底部
     self.pageCt.numberOfPages = models.count;
     self.pageCt.currentPage = selectImgViewIndex;
    
    
    //设置相片
    for (int i = 0; i < models.count ; i ++)
    {
        //取出照片模型
        JJDataModel *model =  models[i];

        //传值给单个图片查看器
        JJOneScrollView *oneScroll = [[JJOneScrollView alloc]init];
        oneScroll.controllerMode = controllerMode;

        //设置位置并添加
        oneScroll.frame = CGRectMake((i * mainScrollW ) + Gap , 0 ,self.frame.size.width, self.frame.size.height);
        [self.mainScroll addSubview:oneScroll];


        //给模型并展示
        oneScroll.model = model;

        //排版
        if(controllerMode){
            [oneScroll showWithAnimation:NO completion:nil];
        }else{
            if(i != selectImgViewIndex){
                [oneScroll showWithAnimation:NO completion:nil];
            }
        }


        //添加到单个滚动创集合
        [self.oneScrolArr addObject:oneScroll];

        //退出回调
        __weak typeof(self) share = self;
        oneScroll.clickBlock = ^{//点击的一瞬间
            if(share.clickBlock){
                share.clickBlock(i);
            }
            if(!controllerMode){
                [share hidenSomeSubview];
            }
        };
        
        oneScroll.willExitBlock = ^{//退出动画完毕后
            if(share.exitComplate){
                share.exitComplate(i);
            }
            [share removeFromSuperview];
        };
    }
    
    //自定义view
    if(self.option.diyView){
        [self addSubview:self.option.diyView];
    }
    
    if(controllerMode){
        [self downloadImgSelfAndLeftRight:selectImgViewIndex];//下载前中后的图
    }else{
        JJOneScrollView *oneScroll  =  self.oneScrolArr[selectImgViewIndex];
        [oneScroll showWithAnimation:YES completion:^{
            [self downloadImgSelfAndLeftRight:selectImgViewIndex];//下载前中后的图
        }];
    }

}

//隐藏所有非相片子控件
-(void)hidenSomeSubview{
    self.pageCt.hidden = YES;
    self.saveBtn.hidden = YES;
    if(self.option.diyView){
        self.option.diyView.hidden = YES;
     }
}


//下载自己+左右两个 imageview节省资源
-(void)downloadImgSelfAndLeftRight:(NSInteger)index{
    //取出自己
    if(index < self.oneScrolArr.count){
        JJOneScrollView *selfScroll =  self.oneScrolArr[index];
        [selfScroll starDownLoadImg];
    }
    
    //取出左边
    if(index != 0 && index - 1 < self.oneScrolArr.count){
        JJOneScrollView *leftScroll =  self.oneScrolArr[index-1];
        [leftScroll starDownLoadImg];
    }
    
    //取出右边
    if(index + 1< self.oneScrolArr.count){
        JJOneScrollView *rightScroll =  self.oneScrolArr[index+1];
        [rightScroll starDownLoadImg];
    }
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentIndex = scrollView.contentOffset.x / self.mainScroll.bounds.size.width;
    self.pageCt.currentPage = currentIndex;
    if(self.pageChangeBlock){
        self.pageChangeBlock(currentIndex);
    }
    [self downloadImgSelfAndLeftRight:currentIndex];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger currentIndex = scrollView.contentOffset.x / self.mainScroll.bounds.size.width;
    self.pageCt.currentPage = currentIndex;
    if(self.pageChangeBlock){
        self.pageChangeBlock(currentIndex);
    }
    [self downloadImgSelfAndLeftRight:currentIndex];
}


-(void)dealloc{
    NSLog(@"main");
}

@end
