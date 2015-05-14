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
{
    BOOL _isdoubleTap;
    
    CGRect _originalRect;
}


@property(nonatomic,weak)UIImageView *mainImageView;


@property(nonatomic,strong)UITapGestureRecognizer *twoTap;

@end
@implementation JJOneScrollView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
     
        self.userInteractionEnabled = NO;
        
        self.delegate = self;
        
     
        UIImageView *mainImageView = [[UIImageView alloc]init];
        mainImageView.userInteractionEnabled = YES;
        [self addSubview:mainImageView];
        self.mainImageView = mainImageView;
        
     
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(goBack:)];
        [tap setNumberOfTapsRequired:1];
        [self addGestureRecognizer:tap];
    
        
        UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc]init];
        [twoTap addTarget:self action:@selector(beginZoom:)];
        [twoTap setNumberOfTapsRequired:2];
        self.twoTap = twoTap;
       
        
        //系统默认的 双击单机共存 但是速度有点慢
       // [tap requireGestureRecognizerToFail:twoTap];
       
        
    }
    return self;
}



#pragma mark - ❤️本地加载图
-(void)setLocalImage:(UIImageView *)imageView
{
    
  
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    CGRect originalRect = [imageView convertRect: imageView.bounds toView:window];
    self.mainImageView.frame = originalRect;
    _originalRect = originalRect ;

   
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
    
   
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    CGRect originalRect = [imageView convertRect: imageView.bounds toView:window];
    self.mainImageView.frame = originalRect;
    _originalRect = originalRect ;
    
    
    [UIView animateWithDuration:AnimationTime animations:^{
        
        [self setFrameAndZoom:imageView];
        self.superview.backgroundColor = [UIColor blackColor];
        self.maximumZoomScale = 1;
        
    } completion:^(BOOL finished) {
        
       
         self.userInteractionEnabled = YES ;
        
       
        
            [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:self.mainImageView.image       options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
               
                
                if (error == nil) {
                    [self addGestureRecognizer:self.twoTap];
                    self.mainImageView.image = image;
                    [self setFrameAndZoom:self.mainImageView];
                }else{
                    
                }
                
            }];
            
        
        
    }];
    
}




#pragma mark - 🈲计算frame 核心代码
-(void)setFrameAndZoom:(UIImageView *)imageView
{
    
    CGFloat   imageH;
    CGFloat   imageW;
    
    
    
    if(imageView.image == nil || imageView.image.size.width == 0 || imageView.image.size.height ==0)
    {
       
        imageH = mainH;
        imageW = mainW;
        self.mainImageView.image = [UIImage imageNamed:@"none"];
        
    }else
    {
       
        imageW  = imageView.image.size.width;
        imageH = imageView.image.size.height;
        self.mainImageView.image = imageView.image;
    }
    
    
    
   
    if(imageW >= (imageH * (mainW/mainH)))
    {
        
       
        CGFloat  myX_ =  0;
        CGFloat  myW_ = mainW;
        CGFloat  myH_  = myW_ *(imageH/imageW);;
        CGFloat  myY_ = mainH - myH_ - ((mainH - myH_)/2);
        
        
        self.mainImageView.frame = CGRectMake(myX_, myY_, myW_, myH_);
        
        
       
        if (imageW >  myW_) {
            self.maximumZoomScale = (imageW/myW_ ) ;
        }else
        {
            self.minimumZoomScale = (imageW/myW_);
        }
        
        
    }else
    {
        
        CGFloat  myH_ = mainH;
        CGFloat  myW_ = myH_ *(imageW/imageH);
        CGFloat  myX_ = mainW - myW_ - ((mainW - myW_)/2);
        CGFloat  myY_ = 0;
        
        
        self.mainImageView.frame = CGRectMake(myX_, myY_, myW_, myH_);
        
        
        if (imageH >  myH_) {
            self.maximumZoomScale =  (imageH/myH_ ) ;
        }else
        {
            self.minimumZoomScale = (imageH/myH_);
        }
    }
    
}


#pragma mark - ❤️滚动栏 代理方法

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
       return self.mainImageView;
}



- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGSize scrollSize = scrollView.bounds.size;
    CGRect imgViewFrame = self.mainImageView.frame;
    CGSize contentSize = scrollView.contentSize;
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    

    if (imgViewFrame.size.width <= scrollSize.width)
    {
        centerPoint.x = scrollSize.width/2;
    }
    

    if (imgViewFrame.size.height <= scrollSize.height)
    {
        centerPoint.y = scrollSize.height/2;
    }
    
    self.mainImageView.center = centerPoint;
}

#pragma mark - ❤️单机 双击 ImageView操作


-(void)goBack:(UITapGestureRecognizer *)tap
{
    _isdoubleTap = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (_isdoubleTap) return;
       
        [self.mydelegate willGoBack:self.myindex];
        
        self.userInteractionEnabled = NO;
        self.zoomScale = 1;
        self.delegate = nil;
        
        [UIView animateWithDuration:AnimationTime animations:^{
            
            self.mainImageView.frame = _originalRect;
            self.superview.backgroundColor = [UIColor clearColor];
            
        } completion:^(BOOL finished) {
            
            if([self.mydelegate respondsToSelector:@selector(goBack)])
            {
                [self.mydelegate goBack];
            }
            
        }];
        
    });
    
}



-(void)beginZoom:(UITapGestureRecognizer*)tap
{
    _isdoubleTap = YES;
    CGPoint touchPoint = [tap locationInView:self];
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:1.0 animated:YES];
    } else {
        CGRect zoomRect;
        zoomRect.size.height = self.frame.size.height / self.maximumZoomScale;
        zoomRect.size.width = self.frame.size.width / self.maximumZoomScale;;
        zoomRect.origin.x = touchPoint.x - (zoomRect.size.width / 2.0);
        zoomRect.origin.y = touchPoint.y - (zoomRect.size.height / 2.0);
        [self zoomToRect:zoomRect animated:YES];
    }
    
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
