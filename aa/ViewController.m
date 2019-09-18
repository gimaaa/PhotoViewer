//
//  ViewController.m
//  aa
//
//  Created by KimBox on 15/6/12.
//  Copyright (c) 2015年 KimBox. All rights reserved.
//   

#import "ViewController.h"
#import "JJPhotoManeger.h"

@interface ViewController ()

@property(nonatomic,strong)NSMutableArray<JJDataModel *> *models;

@end

@implementation ViewController

-(NSMutableArray<JJDataModel *> *)models{
    if(_models == nil){
        _models = [NSMutableArray array];
    }
    return _models;
}


- (void)viewDidLoad {
    [super viewDidLoad];
 
    UIView *t = [[UIView alloc]init];
    t.userInteractionEnabled = YES;
    t.backgroundColor =[UIColor yellowColor];
    t.frame = CGRectMake(66, 78, 500, 500);
    [self.view addSubview:t];
    
    for(int i = 0 ; i < 20 ; i++)
    {
        UIButton *imageV = [[UIButton alloc]init];
        imageV.frame = CGRectMake(i * 60, i * 60, 60, 60);
        [t addSubview:imageV];
        [imageV setBackgroundImage:[UIImage imageNamed:@"141435AZe"] forState:UIControlStateNormal];
      //  [imageV setImage:[UIImage imageNamed:@"141435AZe"]];
        imageV.userInteractionEnabled = YES;
        
        //添加点击操作
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(tap:)];
        [imageV addGestureRecognizer:tap];
        
        
        
        JJDataModel *model = [JJDataModel alloc];
        model.containerView = imageV;
       
       
        
        //随便写点击后显示的图
        if(i == 0){
            model.holdImg =[UIImage imageNamed:@"11.jpg"];
            model.imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568643643867&di=481f07f112b213af30fe0e9065d5aac7&imgtype=0&src=http%3A%2F%2Fwx2.sinaimg.cn%2Forj360%2F9b648b49ly1g2ep6thz0rj20ku1vraz6.jpg";
        }else if(i == 3){
            model.localImgNamed = @"123123.jpg";
            model.imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568643643867&di=481f07f112b213af30fe0e9065d5aac7&imgtype=0&src=http%3A%2F%2Fwx2.sinaimg.cn%2Forj360%2F9b648b49ly1g2ep6thz0rj20ku1vraz6.jpg";
        }else if(i == 4){
            model.holdImg =[UIImage imageNamed:@"11.jpg"];
            model.imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568710152753&di=6fd543f168d194142ffcfc82fa9bc2be&imgtype=0&src=http%3A%2F%2Fi6.hexunimg.cn%2F2015-06-25%2F177033555.jpg";
        }else if(i == 5){
            model.imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568710152753&di=1d15179f354d440fc6fdfef840273c72&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fblog%2F201407%2F11%2F20140711233019_eVisH.thumb.700_0.gif";
        }else if(i == 6){
            model.imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568710152753&di=6f68dcb114d68881b455fbfaa93d57a4&imgtype=0&src=http%3A%2F%2Fphotocdn.sohu.com%2F20150907%2Fmp30771419_1441587171168_8.gif";
        }else if(i == 7){
            model.imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568710152754&di=70a8b3bc8c2b8cf6af9ff729cffe51b5&imgtype=0&src=http%3A%2F%2Fphotocdn.sohu.com%2F20150826%2Fmp29329796_1440565857845_4.gif";
        }else if(i == 8){
            model.imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568710152756&di=be2441806669822ebee2ec95d3092f7e&imgtype=0&src=http%3A%2F%2Fhiphotos.baidu.com%2Ffeed%2Fpic%2Fitem%2F0eb30f2442a7d933b0b7b483a14bd11373f00126.jpg";
        }else if(i == 9){
            model.imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568710152755&di=ab58c5d81d8ae6c3efe3c87d145bf575&imgtype=0&src=http%3A%2F%2Fpic2.zhimg.com%2Fv2-5ac9bac396e7c127b6ac75e5e94a9afd_b.gif";
        }else if(i == 10){
            model.imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568710152755&di=b16dd4a45f565f03dda9a137c90de4cc&imgtype=0&src=http%3A%2F%2Fphotocdn.sohu.com%2F20151016%2Fmp35953484_1444961444580_6.gif";
        }else if(i == 11){
            model.imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568710152755&di=d66b9af900484088e87ed5713b8acacb&imgtype=0&src=http%3A%2F%2Fpic.962.net%2Fup%2F2013-5%2F20135527271154555737.gif";
        }else if(i == 12){
            model.imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568710152755&di=b91ae53f91624c7e91559fd479cb50d7&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20180324%2Fc868aab5a4bc482ba72ab74512fba583.gif";
        }else if(i == 13){
            model.imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568710152755&di=c9828d1982306dc2429ec69ce2b35679&imgtype=0&src=http%3A%2F%2Fphotocdn.sohu.com%2F20160127%2Fmp56795505_1453888090345_14.gif";
    }else if(i == 14){
        model.imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568710152755&di=fb34b4bc7880a22d81155053ba671821&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201206%2F30%2F20120630010815_nxSRZ.thumb.700_0.gif";
    }else if(i == 15){
        model.imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568710152754&di=ed6073f457ef2b6f17a483fbe67ea663&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20160725%2F9f4e63dfad154bc1842ba42d12ae2107.jpg";
    }else if(i == 16){
        model.imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568710152754&di=4ae944c0bd16a43897c77a9e29c4d083&imgtype=0&src=http%3A%2F%2Fphotocdn.sohu.com%2F20150719%2Fmp23323231_1437278547473_4.gif";
    }else{
        model.imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568709984137&di=c85d14eb72e1825dcedaaaea10538666&imgtype=0&src=http%3A%2F%2Fphotocdn.sohu.com%2F20150924%2Fmp33243850_1443100816109_2.gif";
    }
    
        [self.models addObject:model];
    }
}

//图片点击时
-(void)tap:(UITapGestureRecognizer *)tap{
    UIImageView *tapView = (UIImageView *)tap.view;
    JJPhotoManeger *mg = [[JJPhotoManeger alloc]init];
    mg.exitComplate = ^(NSInteger lastSelectIndex) {
        NSLog(@"%zd",lastSelectIndex);
    };
   // [mg showPhotoViewerModels:self.models selectViewIndex:3];
     [mg showPhotoViewerModels:self.models selectView:tapView];
}


@end
