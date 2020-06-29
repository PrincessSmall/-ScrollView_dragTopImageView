# -ScrollView_dragTopImageView
此文解决了两个问题：
>1. 认识contentSize、contentInset、contentOffset；
>2. 在ScrollView上方放一张imageView，实现下拉scrollView图片放大，停止拖拽图片恢复原样的需求；

### 1、contentSize、contentInset、contentOffset的概念

```
contentSize：内容（content）的尺寸
contentOffset：scrollView左上角相对于内容左上角的偏移offset
contentInset：内容的padding，给内容四周加边距

```
这几个概念我总是记不清楚，所以记录一下自己的理解：

**contentSize：**

1. contentSize：scrollView不给contentSize时，不能滚动；
2. conctentSize就是想要展示的内容范围；

**contentInset:**

1. 当设置scrollView的位置为如下代码时：
`_scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds`，在iPhone11 pro模拟器上，打印出来scrollView的位置信息如下：
```
frame = (0 0; 375 812); contentOffset: {0, -44}; contentSize: {375, 1440}; adjustedContentInset: {44, 0, 34, 0}>
```
可以看出系统会自动给scrollView添加一个adjustedContentInset，44和34不难看出其实就是系统在scrollView的上方和下方分别为状态栏和tab栏留了间距。
2. 当我们滑动scrollView的时候，可以发现，除了展示scrollView的上面内容之外，上面还多了状态栏和tab栏。也就是说inset的添加是为了可以在contentSize之外有额外空隙展示其他内容。这里引申出另一个概念，也就是scrollView的移动范围。具体见下方验证；

```
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor lightGrayColor];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.bounds.size.width, 300)];
        imageView.image = [UIImage imageNamed:@"shot"];
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, imageView.frame.origin.y + 300, _scrollView.bounds.size.width, 500)];
        view1.backgroundColor = [UIColor redColor];
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, view1.frame.origin.y + 500, _scrollView.bounds.size.width, 600)];
        view2.backgroundColor = [UIColor blueColor];
        [_scrollView addSubview:imageView];
        [_scrollView addSubview:view1];
        [_scrollView addSubview:view2];
  //看这里      
        _scrollView.contentInset = UIEdgeInsetsMake(100, 100, 100, 100);//这个和contentSize的先后顺序竟然影响后面的展示效果了。TODO
        _scrollView.contentSize = CGSizeMake(175, 1400);//width分别设置为375,275,175依次查看效果
        
//        _scrollView.contentOffset = CGPointMake(0, 0);//即将scrollView的坐标设为图片和色块的坐标原点？这里好像是因为有导航栏，所以就放到了导航栏下面TODO
      
       }
        _scrollView.delegate = self;
    }
    return _scrollView;
}

/*
将contentSize的width分别设置成375、275、175并配合contentInset为{100，100，100，100，100}的效果；
1. 375:左右各有100的空白宽度出来；
2. 275:左边有100宽度的空白留出来，右边刚好贴着子view的边缘。因为移动范围变成了contentSiz.width+contentInset.left也就是275+200=475；
3. 175:左边有100宽度的空白留出来，右边子view没有展示完全，并且scrollView不能移动。因为移动范围=175+200=375，不大于scrollView的宽度，所以左右不能移动。
*/
```

3. scrollView可以移动的范围为contentSize+contentInset的大小。（就是说横轴x的范围是contentSize.width + contentInset.left + contentInset.right;纵轴y的范围是contentSize.height + contentInset.top + contentInset.bottom） 

**contentOffset：**

1. scrollView左上角相对于内容左上角的偏移（自己理解的就是scrollView左上角没有被内容填满的时候为负，被填满并超过了为正）；
2. 查看上方设置scrollView位置的时候打印出来的scrollView信息，其中contentOffset为{0, -44}。因为scrollView上方预留了一个statusBar的距离，也就是内容没有填满scrollView，y方向为-44；


### 2. 实现下拉放大scroolView顶部图片
> 原理：利用scrollView的滚动修改图片的frame实现放大效果

步骤1. 在scrollView顶部增加一个图片高度，使用conentInset实现`scrollView.contentInset = UIEdgeInsetsMake(396, 0, 0, 0)`，写396是因为还有一个statusBar的优化高度44，44+396=440；
步骤2. 调整topImageView的origin.y的为-440，使得imageView偏移到contentView上方，`topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -440, self.scrollView.frame.size.width, 440)`
步骤三：根据scrollView的滚动调整图片的位置和高度，只需要修改图片的y和height值。

具体实现见demo：

以上理解是看了以下分享后自己的理解，此文章写的很清晰明了，我这边记录下来是希望按照自己思路做一个知识整理和记忆。
[木小易ying的ScrollView的contentInset / contentOffset / contentSize](https://www.jianshu.com/p/f0eeef56f391)
