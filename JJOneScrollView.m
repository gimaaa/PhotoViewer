//
//  JJOneScrollView.m
//  test
//
//  Created by KimBox on 15/5/4.
//  Copyright (c) 2015年 KimBox. All rights reserved.
//

#import "JJOneScrollView.h"
#import "UIImageView+WebCache.h"

#define AnimationTime 0.4
#define  mainW [UIScreen mainScreen].bounds.size.width
#define  mainH [UIScreen mainScreen].bounds.size.height


@interface JJOneScrollView()<UIScrollViewDelegate>


//每个滚动控制器自带一个核心相片
@property(nonatomic,weak)UIImageView *mainImageView;


@property(nonatomic,assign)CGRect originalRect;


@property(nonatomic,strong)UITapGestureRecognizer *twoTap;



@end
@implementation JJOneScrollView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //页面不能点击
        self.userInteractionEnabled = NO;
        
        //代理
        self.delegate = self;
        
        //添加主图片显示View
        UIImageView *mainImageView = [[UIImageView alloc]init];
        mainImageView.userInteractionEnabled = YES;
        [self addSubview:mainImageView];
        self.mainImageView = mainImageView;
        
        //点击时返回退出
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(goBack:)];
        [tap setNumberOfTapsRequired:1];
        [self addGestureRecognizer:tap];
        
        //双击
        UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc]init];
        [twoTap addTarget:self action:@selector(shuangji:)];
        [twoTap setNumberOfTapsRequired:2];
        self.twoTap = twoTap;
       
        
        [tap requireGestureRecognizerToFail:twoTap];
       
        
    }
    return self;
}

//双击放大嘛 哈哈
-(void)shuangji:(UITapGestureRecognizer*)tap
{
    
    CGPoint touchPoint = [tap locationInView:self];
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        CGRect zoomRect;
        zoomRect.size.height = self.frame.size.height / self.maximumZoomScale;
        zoomRect.size.width = self.frame.size.width / self.maximumZoomScale;;
        zoomRect.origin.x = touchPoint.x - (zoomRect.size.width / 2.0);
        zoomRect.origin.y = touchPoint.y - (zoomRect.size.height / 2.0);
        [self zoomToRect:zoomRect animated:YES];
    }
    
}

#pragma mark - ❤️本地加载图
-(void)setLocalImage:(UIImageView *)imageView
{
    
    //初始位置
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    CGRect originalRect = [imageView convertRect: imageView.bounds toView:window];
    self.mainImageView.frame = originalRect;
    self.originalRect = originalRect ;

    //动画变换设置frame
    [UIView animateWithDuration:AnimationTime animations:^{
        
        [self setFrameAndZoom:imageView];
        self.superview.backgroundColor = [UIColor blackColor];
        
    } completion:^(BOOL finished) {
        
        self.userInteractionEnabled = YES ;
        [self addGestureRecognizer:self.twoTap];
    }];
    
}



#pragma mark - ❤️加载网络图
-(void)setNetWorkImage:(UIImageView *)imageView urlStr:(NSString *)urlStr
{
    
    //初始位置
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    CGRect originalRect = [imageView convertRect: imageView.bounds toView:window];
    self.mainImageView.frame = originalRect;
    self.originalRect = originalRect ;
    
    //动画变换设置frame与背景颜色
    [UIView animateWithDuration:AnimationTime animations:^{
        
        [self setFrameAndZoom:imageView];
        self.superview.backgroundColor = [UIColor blackColor];
        self.maximumZoomScale = 1;
        
    } completion:^(BOOL finished) {
        
       
         self.userInteractionEnabled = YES ;
        
       
            //变换完动画 从网络开始加载图
            [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:self.mainImageView.image       options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
               
                
                if (error == nil) { //下载成功
                    [self addGestureRecognizer:self.twoTap];
                    self.mainImageView.image = image;
                    [self setFrameAndZoom:self.mainImageView];//设置最新的网络下载后的图的frame大小
                    
                }else{ //下载失败
                    
                }
                
            }];
            
        
        
    }];
    
}




#pragma mark - 🈲计算frame 核心代码
-(void)setFrameAndZoom:(UIImageView *)imageView
{
    //ImageView.image的大小
    CGFloat   imageH;
    CGFloat   imageW;
    
    
    //设置空image时的情况
    if(imageView.image == nil || imageView.image.size.width == 0 || imageView.image.size.height ==0)
    {
        //设置主图片
        imageH = mainH;
        imageW = mainW;
        self.mainImageView.image = [UIImage imageNamed:@"none"];
        
    }else//不空
    {
        //设置主图片
        imageW  = imageView.image.size.width;
        imageH = imageView.image.size.height;
        self.mainImageView.image = imageView.image;
    }
    
    
    
    //设置主图片Frame 与缩小比例
    if(imageW >= (imageH * (mainW/mainH)))//横着
    {
        
        //设置居中frame
        CGFloat  myX_ =  0;
        CGFloat  myW_ = mainW;
        CGFloat  myH_  = myW_ *(imageH/imageW);;
        CGFloat  myY_ = mainH - myH_ - ((mainH - myH_)/2);
        
        
        self.mainImageView.frame = CGRectMake(myX_, myY_, myW_, myH_);
        
        
        //判断原图是小图还是大图来判断,是可以缩放,还是可以放大
        if (imageW >  myW_) {
            self.maximumZoomScale = (imageW/myW_ ) ;//放大比例
        }else
        {
            self.minimumZoomScale = (imageW/myW_);//缩小比例
        }
        
        
    }else//竖着
    {
        
        CGFloat  myH_ = mainH;
        CGFloat  myW_ = myH_ *(imageW/imageH);
        CGFloat  myX_ = mainW - myW_ - ((mainW - myW_)/2);
        CGFloat  myY_ = 0;
        
        //变换设置frame
        self.mainImageView.frame = CGRectMake(myX_, myY_, myW_, myH_);
        
        //判断原图是小图还是大图来判断,是可以缩放,还是可以放大
        if (imageH >  myH_) {
            self.maximumZoomScale =  (imageH/myH_ ) ;//放大比例
        }else
        {
            self.minimumZoomScale = (imageH/myH_);//缩小比例
        }
    }
    
}


#pragma mark - ❤️滚动栏 代理方法
//开始缩放,一开始会自动调用几次,并且要返回告来诉scroll我要缩放哪一个控件.
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
       return self.mainImageView;
}


//缩放时调用 ,确定中心点代理方法
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGSize scrollSize = scrollView.bounds.size;
    CGRect imgViewFrame = self.mainImageView.frame;
    CGSize contentSize = scrollView.contentSize;
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

#pragma mark - ❤️通知代理调用 GoBack

//图片点击后返回原来的image
-(void)goBack:(UITapGestureRecognizer *)tap
{

    
    //通知代理 我即将消失,给你我的序号
    [self.mydelegate willGoBack:self.myindex];
    
    self.userInteractionEnabled = NO;
    self.zoomScale = 1;
    self.delegate = nil;
    
    [UIView animateWithDuration:AnimationTime animations:^{
        
        self.mainImageView.frame = self.originalRect;
        self.superview.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        
        if([self.mydelegate respondsToSelector:@selector(goBack)])
        {
            [self.mydelegate goBack];
        }
        
    }];
    
}


#pragma mark - ❤️回复原状
-(void)reloadFrame
{
    self.zoomScale = 1;
}

#pragma mark - 😢释放代理防崩
-(void)dealloc
{
    self.delegate = nil;
}


@end
