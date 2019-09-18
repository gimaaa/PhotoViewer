
#import "JJOneScrollView.h"
#import "UIImageView+WebCache.h"

#define AnimationTime 0.25 //缩放动画时间
#define MaxZoomScale 5 //最大放大系数

#define  MYMainW [UIScreen mainScreen].bounds.size.width
#define  MYMainH [UIScreen mainScreen].bounds.size.height


@interface JJOneScrollView()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
//滚动
@property(nonatomic,strong)UIScrollView *oneScrollView;
//加载等待菊花
@property(nonatomic,strong)UIActivityIndicatorView *activityIndicator;
//每个滚动控制器自带一个显示相片
@property(nonatomic,strong)UIImageView *mainImageView;
//图片下载前展示的图
@property(nonatomic,strong)UIImage *holdImg;
//图片图是否下载完成过
@property(nonatomic,assign)BOOL downloadComplate;

@end
@implementation JJOneScrollView

-(UIImage *)holdImg{
    if(_holdImg == nil){
        if(self.model.holdImg){
            _holdImg = self.model.holdImg;
        }else{
            if([self.model.containerView isKindOfClass:[UIImageView class]]){
                UIImageView *imageV = (UIImageView *)self.model.containerView;
                _holdImg = imageV.image;
            }else if ([self.model.containerView isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)self.model.containerView;
                
                if(btn.currentBackgroundImage){
                    _holdImg = btn.currentBackgroundImage;
                }else{
                    _holdImg =  btn.currentImage;
                }
            }
        }
    }
    return _holdImg;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.oneScrollView.frame = self.bounds;
    self.activityIndicator.frame = CGRectMake(self.frame.size.width/2-17, self.frame.size.height/2-17, 34, 34);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        //页面默认先不能点击
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;

        //uiscrollView
        UIScrollView *oneScrollView = [[UIScrollView alloc]init];
        oneScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:oneScrollView];
        self.oneScrollView = oneScrollView;
        self.oneScrollView.delegate = self;
        
        
        //添加主图片显示View
        UIImageView *mainImageView = [[UIImageView alloc]init];
        mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        mainImageView.clipsToBounds = YES;
        mainImageView.userInteractionEnabled = YES;
        [self.oneScrollView addSubview:mainImageView];
        self.mainImageView = mainImageView;
        
        
        //点击
        UITapGestureRecognizer *singleTapGR, *doubleTapGR;
        singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(goBack:)];//退出
        singleTapGR.delegate = self;
        doubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(zoom:)];//放大
        doubleTapGR.numberOfTapsRequired = 2;
        doubleTapGR.delegate = self;
    
        //当你需要使用单击时请求双击事件失败.
        [singleTapGR requireGestureRecognizerToFail:doubleTapGR];
        
        [self addGestureRecognizer:singleTapGR];
        [self addGestureRecognizer:doubleTapGR];
  
       
        //菊花
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
        self.activityIndicator.hidesWhenStopped = YES;
        self.activityIndicator.color = [UIColor whiteColor];
        [self addSubview:self.activityIndicator];
    }
    return self;
}

#pragma mark - 计算frame展示图片 核心代码
-(void)setFrameAndZoom:(UIImage *)img
{
    //相片数据画布的大小
    CGFloat   imageH;
    CGFloat   imageW;
    
    //缩放回复原状
    self.oneScrollView.zoomScale = 1;
    
    //设置空image时的情况
    if(img == nil || img.size.width == 0 || img.size.height ==0)
    {
        //设置空图
        imageH = MYMainH;
        imageW = MYMainW;
        self.mainImageView.image = [[UIImage alloc]init];
        
    }else//不空
    {
        //设置主图片
        imageW  = img.size.width;
        imageH = img.size.height;
        self.mainImageView.image = img;
    }
    
    //设置主图片Frame 与缩小比例
    if(imageW >= (imageH * (MYMainW/MYMainH)))//横着
    {
        
        //设置居中frame
        CGFloat  myX_ =  0;
        CGFloat  myW_ = MYMainW;
        CGFloat  myH_  = myW_ *(imageH/imageW);;
        CGFloat  myY_ = MYMainH - myH_ - ((MYMainH - myH_)/2);
        
        //变换设置frame
        self.mainImageView.frame = CGRectMake(myX_, myY_, myW_, myH_);
        
        self.oneScrollView.maximumZoomScale = MaxZoomScale;
        self.oneScrollView.minimumZoomScale = 1;
        
        
    }else//竖着
    {
        //设置居中frame
        CGFloat  myH_ = MYMainH;
        CGFloat  myW_ = myH_ *(imageW/imageH);
        CGFloat  myX_ = MYMainW - myW_ - ((MYMainW - myW_)/2);
        CGFloat  myY_ = 0;
        
        //变换设置frame
        self.mainImageView.frame = CGRectMake(myX_, myY_, myW_, myH_);
        
        self.oneScrollView.maximumZoomScale = MaxZoomScale;
        self.oneScrollView.minimumZoomScale = 1;
    }
}


#pragma mark -  展示内容
-(void)showWithAnimation:(BOOL)animation completion:(void (^)(void))completion{
    
        if(animation){ //刚好展示在屏目前的
            
            if(self.model.containerView == nil){//1:没有给到容器的时候
                [self setFrameAndZoom:self.holdImg];
                self.alpha = 0;
         
            }else{//2:有给容器的时候
                UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
                CGRect originalRect = [self.model.containerView convertRect:self.model.containerView.bounds toView:window];
                self.mainImageView.frame = originalRect;
                
            }

            [UIView animateWithDuration:AnimationTime animations:^{
                
                if(self.model.containerView == nil){//1:没有给到容器的时候
                    self.alpha = 1;
                    
                }else{//2:有给容器的时候
                    [self setFrameAndZoom:self.holdImg];
                }

                self.superview.backgroundColor = [UIColor blackColor];
                
            } completion:^(BOOL finished) {
                self.userInteractionEnabled = YES ;
                if(completion){
                    completion();
                }
            }];
            
        }else{//其他看不见的 直接放置好
            [self setFrameAndZoom:self.holdImg];
            self.userInteractionEnabled = YES ;
            
        }
   
}



#pragma mark -  加载
-(void)starDownLoadImg{
    
    //加载成功过的无序重复加载
    if(self.downloadComplate){
        return;
    }
    
    
    //网图
    if(self.model.imgUrl.length){
        [self.activityIndicator startAnimating];
        
            //!!!!⚠️⚠️⚠️(可以根据自己项目中的下载框架,进行替换)⚠️⚠️⚠️
            [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imgUrl] placeholderImage:self.holdImg  options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                //用户不可点击状态下都是动画缩放状态,不能用setFrameAndZoom来再改变frame大小,会影响动画效果
                if(self.userInteractionEnabled == NO){
                    return ;
                }
                
                //下载成功✅
                if (error == nil) {
                    [self.activityIndicator stopAnimating];
                    [self setFrameAndZoom:image];//设置最新的网络下载后的图的frame大小
                    self.downloadComplate = YES;//下载成功过
                    
                }else{//下载失败❌
                    
                    //试着加载本地图
                    if(self.model.localImgNamed.length){
                        [self setFrameAndZoom:[UIImage imageNamed:self.model.localImgNamed]];
                        self.downloadComplate = YES;//加载成功
                    }
                }
            }];
        
        return;
    }
    
    
    //本地图
    if(self.model.imgUrl.length == 0){
        if(self.model.localImgNamed.length){
            [self setFrameAndZoom:[UIImage imageNamed:self.model.localImgNamed]];
        }
        self.downloadComplate = YES;//加载成功
        return;
    }
}



#pragma mark - ❤️单机 双击 ImageView操作
//单机返回
-(void)goBack:(UITapGestureRecognizer *)tap{
    
    //通知父控件隐藏子控件
    if(self.backBlock){
        self.backBlock(YES);
    }
    
    self.userInteractionEnabled = NO;
    [self.activityIndicator stopAnimating];
    self.oneScrollView.zoomScale = 1;
    
    [UIView animateWithDuration:AnimationTime animations:^{
        
        if(self.model.containerView){//1:有给容器
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            CGRect originalRect = [self.model.containerView convertRect:self.model.containerView.bounds toView:window];
            self.mainImageView.frame = originalRect;
            
        }else{//2:没给容器
            self.alpha = 0;
        }
        
        self.superview.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        if(self.backBlock){//通知父控自毁
            self.backBlock(NO);
        }
    }];

};

//双击缩/放
-(void)zoom:(UITapGestureRecognizer *)tap{

    if (self.oneScrollView.zoomScale > 1) {//缩小
        [self.oneScrollView setZoomScale:1.0 animated:YES];

    } else {//放大
        CGPoint touchPoint = [tap locationInView:self.mainImageView];
        
        CGFloat scale = self.oneScrollView.maximumZoomScale;
        CGRect newRect = [self getRectWithScale:scale/2.0 andCenter:touchPoint];//双击放大只能放大最大系数的一半
        [self.oneScrollView zoomToRect:newRect animated:YES];

    }
}


/** 计算点击点所在区域frame */
- (CGRect)getRectWithScale:(CGFloat)scale andCenter:(CGPoint)center{
    CGRect newRect = CGRectZero;

    newRect.size.width =  self.mainImageView.frame.size.width/scale;
    newRect.size.height = self.mainImageView.frame.size.height/scale;
    
    newRect.origin.x = center.x - newRect.size.width * 0.5;
    newRect.origin.y = center.y - newRect.size.height * 0.5;
    return newRect;
}



#pragma mark - ❤️缩放代理
//开始缩放,一开始会自动调用几次,并且要返回告来诉scroll我要缩放哪一个控件.
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.mainImageView;
}

//缩放时调用,时刻对齐中心位置
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize scrollSize = scrollView.bounds.size;
    CGRect imgViewFrame = self.mainImageView.frame;
    CGSize contentSize = scrollView.contentSize;
    //放大时对齐
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);

    // 竖着长的 就是垂直居中
    if (imgViewFrame.size.width <= scrollSize.width)
    {
        centerPoint.x = scrollSize.width/2;
    }

    // 横着长的  就是水平居中
    if (imgViewFrame.size.height <= scrollSize.height)
    {
        centerPoint.y = scrollSize.height/2;
    }

    self.mainImageView.center = centerPoint;
}

-(void)dealloc{
    //⚠️⚠️⚠️clear内存缓存//!!!!(可以根据自己项目中的下载框架,进行替换)⚠️⚠️⚠️
    [[SDImageCache sharedImageCache] clearMemory];
    NSLog(@"sub");
}

@end
