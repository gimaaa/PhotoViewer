
#import "JJMainScrollView.h"
#import "JJDataModel.h"
#import "JJOneScrollView.h"

#define Gap 10   //俩照片间黑色间距的一半

@interface JJMainScrollView()<UIScrollViewDelegate>


//存放了所有 单个滚动器
@property(nonatomic,strong)NSMutableArray *oneScrolArr;

//滚动
@property(nonatomic,strong)UIScrollView *mainScroll;

//底部小圆点
@property(nonatomic,strong)UIPageControl *pageCt;

@end


@implementation JJMainScrollView

-(void)layoutSubviews{
    [super layoutSubviews];
    self.mainScroll.frame = CGRectMake(-Gap, 0,self.frame.size.width + Gap + Gap,self.frame.size.height);
    self.pageCt.bounds = CGRectMake(0, 0, self.frame.size.width, 35);
    self.pageCt.center = CGPointMake(self.frame.size.width/2, self.frame.size.height -   self.pageCt.bounds.size.height/2);
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
        mainScroll.backgroundColor = [UIColor clearColor];
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

    }
    return self;
}



-(void)showAndSetModels:(NSArray<JJDataModel *> *)models selectImgViewIndex:(NSInteger)selectImgViewIndex{
    
    
    CGFloat mainScrollW = self.frame.size.width + 2 * Gap;
    //设置可滚动范围
    self.mainScroll.contentSize =  CGSizeMake(models.count * mainScrollW, 0);
    
    //设置首个展示页面
    self.mainScroll.contentOffset = CGPointMake(selectImgViewIndex * mainScrollW, 0);
    
    
    //设置相片
    for (int i = 0; i < models.count ; i ++)
    {
        //取出照片模型
        JJDataModel *model =  models[i];

        //传值给单个图片查看器
        JJOneScrollView *oneScroll = [[JJOneScrollView alloc]init];


        //设置位置并添加
        oneScroll.frame = CGRectMake((i * mainScrollW ) + Gap , 0 ,self.frame.size.width, self.frame.size.height);
        [self.mainScroll addSubview:oneScroll];


        //给模型并展示
        oneScroll.model = model;

        //不在屏幕可是范围内的先排布置版好
        if(i != selectImgViewIndex){
            [oneScroll showWithAnimation:NO completion:nil];
        }

        //添加到单个滚动创集合
        [self.oneScrolArr addObject:oneScroll];

        
        //退出回调
        __weak typeof(self) share = self;
        oneScroll.backBlock = ^(BOOL animating) {
            if(animating){//刚点击退出,正在动画中,
                
                [share hidenSomeSubview];
                
            }else{//动画执行完了 可以自毁了
                if(share.exitComplate){
                    share.exitComplate(i);
                }
                [share removeFromSuperview];
            }
        };
    }


    //屏幕中即将展示的那个
    JJOneScrollView *oneScroll = self.oneScrolArr[selectImgViewIndex];
    //动画形式展示完毕后
    [oneScroll showWithAnimation:YES completion:^{
        [self downloadImgSelfAndLeftRight:selectImgViewIndex];//下载前中后的图
        //底部
        self.pageCt.numberOfPages = models.count;
        self.pageCt.currentPage = selectImgViewIndex;
    }];
   
}

//隐藏所有非相片子控件
-(void)hidenSomeSubview{
    self.pageCt.hidden = YES;
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
    [self downloadImgSelfAndLeftRight:currentIndex];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger currentIndex = scrollView.contentOffset.x / self.mainScroll.bounds.size.width;
    self.pageCt.currentPage = currentIndex;
    [self downloadImgSelfAndLeftRight:currentIndex];
}


-(void)dealloc{
    NSLog(@"main");
}

@end
