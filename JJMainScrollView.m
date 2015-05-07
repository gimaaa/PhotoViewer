//
//  JJMainScrollView.m
//  test
//
//  Created by KimBox on 15/4/28.
//  Copyright (c) 2015年 KimBox. All rights reserved.
//

#import "JJMainScrollView.h"
#import "JJPhoto.h"
#import "JJOneScrollView.h"

#define Gap 10

#define MianW [UIScreen mainScreen].bounds.size.width
#define MianH [UIScreen mainScreen].bounds.size.height

#define RGBColor(r , g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/1.0 ]
#define RandomColor RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

@interface JJMainScrollView()<UIScrollViewDelegate,JJOneScrollViewDelegate>

@property(nonatomic,strong)NSMutableArray *oneScrolArr;

@property(nonatomic,assign)NSInteger willBeginDraggingIndex;
@end


@implementation JJMainScrollView





-(NSMutableArray *)oneScrolArr
{
    if(_oneScrolArr == nil)
    {
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

        
        
        self.frame = CGRectMake(-Gap, 0, [UIScreen mainScreen].bounds.size.width + Gap + Gap,[UIScreen mainScreen].bounds.size.height);
        
       
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        
        
        self.delegate = self;
        
    }
    return self;
}

#pragma mark - 拿到数据时展示

-(void)setPhotoData:(NSArray *)photoArr Type:(JJPhotoViewerType)type
{
    
   
    self.contentSize =  CGSizeMake(photoArr.count * self.frame.size.width, 0);
    
    
    
    NSInteger selcImageIndex;
    for(int i = 0 ; i < photoArr.count ; i ++)
    {
        JJPhoto *photo = photoArr[i];
        if(photo.isSelecImageView == YES)
        {
            selcImageIndex = i;
            break;
        }
    }
    
    
    self.contentOffset = CGPointMake(selcImageIndex * self.frame.size.width, 0);
    
    
    
    
    for (int i = 0; i < photoArr.count ; i ++)
    {
                JJPhoto *photo =  photoArr[i];
        
        JJOneScrollView *oneScroll = [[JJOneScrollView alloc]init];
        oneScroll.mydelegate = self;
        
        oneScroll.myindex = i;
        
        oneScroll.frame = CGRectMake((i*self.frame.size.width)+Gap , 0 ,MianW, MianH);
        [self addSubview:oneScroll];
        
        
        
        switch (type) {
                
                
            case JJLocalWithLocalPhotoViewer:
                [oneScroll setLocalImage:photo.imageView];
                break;
                
                
            case JJInternetWithInternetPhotoViewer:
                [oneScroll setNetWorkImage:photo.imageView urlStr:photo.urlStr];
                break;
        }
        
      
        [self.oneScrolArr addObject:oneScroll];
        
    }
    
}


#pragma mark - 😄滚动监听 重置缩放
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSInteger x = scrollView.contentOffset.x;
    NSInteger w = scrollView.bounds.size.width;
    NSInteger gapHead = (x % w);
    NSInteger mainW =   self.frame.size.width ;
    int gapEnd =  mainW - gapHead;
    
    
    if(fabs(gapHead) <= 20.0 ||fabs(gapEnd) <= 20.0  )
    {
        
        NSInteger  nowLookIndex =( scrollView.contentOffset.x + (scrollView.bounds.size.width/2)) /scrollView.bounds.size.width  ;
        
   
        
        for(int i = 0;i < self.oneScrolArr.count ; i++  )
        {
            if (i != nowLookIndex) {
                JJOneScrollView *one = self.oneScrolArr[i];
                [one reloadFrame];
            }else
            {

                

            }
        }
    }
}






#pragma mark - OneScroll的代理方法


-(void)willGoBack:(NSInteger)seletedIndex
{
      [self.mainDelegate photoViwerWilldealloc:seletedIndex];
}


-(void)goBack
{

    [self.superview removeFromSuperview];
}

#pragma mark - 😢释放代理防崩
-(void)dealloc
{
    self.delegate = nil;
}

@end
