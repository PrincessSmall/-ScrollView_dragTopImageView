//
//  ViewController.m
//  ScrollView_dragTopImageView
//
//  Created by Limin on 2020/6/29.
//  Copyright © 2020 Limin. All rights reserved.
/*
 frame = (0 0; 375 812); contentOffset: {0, -44}; contentSize: {375, 1440}; adjustedContentInset: {44, 0, 34, 0}>
 */

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *topImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    [self setUpScrollView];
    // Do any additional setup after loading the view.
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint scrollViewPoint = scrollView.contentOffset;//步骤三：根据scrollView的滚动调整图片的位置和高度
    if (scrollViewPoint.y < -440) {//若向下拖拽
        CGRect imageRect = self.topImageView.frame;//保持topImageView不动，并且height变大
        imageRect.origin.y = scrollViewPoint.y;
        imageRect.size.height = -scrollViewPoint.y;
        self.topImageView.frame = imageRect;
    }
}

//添加scrollView的子view
- (void)setUpScrollView {
    UIView *blueView = [[UIView alloc]initWithFrame:CGRectMake(0, self.topImageView.frame.origin.y+440, self.scrollView.frame.size.width, 500)];
    blueView.backgroundColor = [UIColor blueColor];
    UIView *greenView = [[UIView alloc]initWithFrame:CGRectMake(0, blueView.frame.origin.y+400, self.scrollView.frame.size.width, 500)];
       greenView.backgroundColor = [UIColor greenColor];
    [self.scrollView addSubview:self.topImageView];
    [self.scrollView addSubview:blueView];
    [self.scrollView addSubview:greenView];
}


#pragma lazy
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        
        _scrollView.contentInset = UIEdgeInsetsMake(396, 0, 0, 0);//步骤1. 使用scrollView的contentInset在scrollView的contentView上方增加一个图片高度440，写396是因为还有一个statusBar的优化高度44，44+396=440；
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1440);//默认scrollView的上下都加了statusBar和tabBar的间距，也就是contentInset
        _scrollView.delegate = self;
        
    }
    return _scrollView;
}
- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -440, self.scrollView.frame.size.width, 440)];//步骤2. 调整topImageView的origin.y的偏移为440，使得imageView偏移到contentView上方、也就是inset优化的地方。
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
        _topImageView.image = [UIImage imageNamed:@"shot"];
    }
    return _topImageView;
}

@end
