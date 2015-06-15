//
//  ViewController.m
//  aa
//
//  Created by KimBox on 15/6/12.
//  Copyright (c) 2015年 KimBox. All rights reserved.
//

#import "ViewController.h"
#import "JJPhotoManeger.h"

@interface ViewController ()<JJPhotoDelegate>

@property(nonatomic,strong)NSMutableArray *imageArr;

@property(nonatomic,strong)NSMutableArray *picUrlArr;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _imageArr = [NSMutableArray array];
    _picUrlArr = [NSMutableArray array];
    
    for(int i = 0 ; i < 10 ; i++)
    {
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake(i * 60, i * 60, 60, 60);
        [self.view addSubview:image];
        [image setImage:[UIImage imageNamed:@"141435AZe"]];
        image.userInteractionEnabled = YES;
        //imageView 放入数组
        [_imageArr addObject:image];
        //imageView的网络图片地址
        [_picUrlArr addObject:@"http://www.guimobile.net/blog/uploads/2014/05/141435AZe.jpg"];
        
        //添加点击操作
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(tap:)];
        [image addGestureRecognizer:tap];

    }
}

//聊天图片放大浏览
-(void)tap:(UITapGestureRecognizer *)tap
{
    
    UIImageView *view = (UIImageView *)tap.view;
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    mg.delegate = self;
    [mg showNetworkPhotoViewer:_imageArr urlStrArr:_picUrlArr selecView:view];
 
}

-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    
    NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
