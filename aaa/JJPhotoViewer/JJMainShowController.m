//
//  JJMainShowController.m
//  CZManage
//
//  Created by 金正国 on 2020/3/13.
//  Copyright © 2020 CYHC. All rights reserved.
//

#import "JJMainShowController.h"
#import "JJMainScrollView.h"

@interface JJMainShowController ()

@property(nonatomic,strong)UIView *navi;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)JJMainScrollView *mainScrollView;
@end

@implementation JJMainShowController

-(void)setUPView{
    //导航栏
    UIView *navi =  [[UIView alloc]init];
    navi.backgroundColor = [UIColor whiteColor];
    navi.frame = CGRectMake(0, 0, self.view.frame.size.width, [[UIApplication sharedApplication] statusBarFrame].size.height + 44);
    [self.view addSubview:navi];
    self.navi = navi;
    
    //返回
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height, 44, 44)];
    [navi addSubview:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];
    
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor blackColor];
    label.text = [NSString stringWithFormat:@"%zd/%zd",self.selectViewIndex+1,self.models.count];
    label.textAlignment = NSTextAlignmentCenter;
    label.bounds = CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height, 200, 44);
    label.center = CGPointMake(navi.frame.size.width/2, [[UIApplication sharedApplication] statusBarFrame].size.height + 22);
    [navi addSubview:label];
    self.label = label;
    
    //删除
    UIButton *del = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width -44, [[UIApplication sharedApplication] statusBarFrame].size.height, 44, 44)];
    if(self.deleteComplate){
          [navi addSubview:del];
    }
    [del addTarget:self action:@selector(del) forControlEvents:UIControlEventTouchUpInside];
    [del setImage:[UIImage imageNamed:@"bottom_delete"] forState:UIControlStateNormal];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hidenshowBar];
    });
}

-(void)hidenshowBar{
    [UIView animateWithDuration:0.2 animations:^{
        self.navi.alpha = !self.navi.alpha;
    }completion:^(BOOL finished) {
        self.navi.tag = self.navi.tag == 999 ? 0 : 999;
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    //主窗口
    __weak typeof(self) share = self;
    JJMainScrollView *mainScrollView = [[JJMainScrollView alloc]init];
    mainScrollView.option = self.option;
    mainScrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview: mainScrollView];
    self.mainScrollView = mainScrollView;
    
    mainScrollView.clickBlock = ^(NSInteger Index) {
        [share hidenshowBar];
    };
    
    mainScrollView.pageChangeBlock = ^(NSInteger selectViewIndex) {
        share.selectViewIndex = selectViewIndex;
        share.label.text = [NSString stringWithFormat:@"%zd/%zd",selectViewIndex+1,share.models.count];
    };
    //如果index给错了防止崩溃当点击了第一个图
    if(self.selectViewIndex >= self.models.count){
        self.selectViewIndex = 0;
    }
    
    //展示图片们
    [mainScrollView showAndSetModels:self.models selectImgViewIndex:self.selectViewIndex controllerMode:YES];
    
    //地图
    [self setUPView];
}



-(void)del{
    if(self.deleteComplate){
        __weak typeof(self) share = self;
        void (^delete)(void) = ^void (void){
            NSMutableArray *tem = [[NSMutableArray alloc]initWithArray:share.models];
            [tem removeObjectAtIndex:share.selectViewIndex];
            share.models = tem;
            
            //删了最后的
            if(share.models.count > 0 && share.selectViewIndex == share.models.count){
                share.selectViewIndex = share.selectViewIndex - 1;
            }
            //没了
            if (share.models.count == 0){
                [share back];
            }else{
                //重排版
                [share.mainScrollView showAndSetModels:share.models selectImgViewIndex:share.selectViewIndex controllerMode:YES];
                share.label.text = [NSString stringWithFormat:@"%zd/%zd",share.selectViewIndex+1,share.models.count];
            }
        };

        self.deleteComplate(self.selectViewIndex,delete);
    }
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)dealloc{
    
}
@end
