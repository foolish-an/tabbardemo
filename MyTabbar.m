//
//  MyTabbar.m
//  MyTabbarDemo
//
//  Created by qianfeng on 15-3-15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MyTabbar.h"
#import "GALMainViewController.h"
#import "GALAppDelegate.h"
@implementation MyTabbar

{
    UITabBarController *_tbc;
    UIButton *_selectedButton;
    UILabel *_selectedLabel;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - mainFunc

//创建系统tabbar
-(void)createTabbarController
{
    NSMutableArray *vcs = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<5; i++) {
        GALMainViewController *main1 = [[GALMainViewController alloc]init];
        main1.title = [NSString stringWithFormat:@"%d",i];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:main1];
        
        [vcs addObject:nav];
        
    }
    _tbc = [[UITabBarController alloc]init];
    _tbc.viewControllers = vcs;
    
    GALAppDelegate *app = [UIApplication sharedApplication].delegate;
    
    app.window.rootViewController = _tbc;
    
    
    
}
//创建自定义tabbar
-(void)createMytabbar
{
    //plist文件读取成字典
    NSDictionary *plistDict = [self loadTabbarPlist];
    
    //创建背景图
    [self createBgImageWithImageName:[plistDict objectForKey:@"bgImageName"]];
    
    
    //创建items
    for (int i = 0; i<((NSArray *) [plistDict objectForKey:@"Items"]).count; i++) {
        [self createItemWithItemDict:[[plistDict objectForKey:@"Items"] objectAtIndex:i] andItemIdenx:i andCount:((NSArray *) [plistDict objectForKey:@"Items"]).count];
    }
}
#pragma mark - sunFunc
-(NSDictionary  *)loadTabbarPlist
{
    NSString *path = [NSString stringWithFormat:@"%@/tabbarList.plist",[[NSBundle mainBundle] resourcePath]];
    NSDictionary *plistDict = [[NSDictionary alloc]initWithContentsOfFile:path];
    
    return plistDict;
}

-(void)createBgImageWithImageName:(NSString *)bgImageName
{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:bgImageName]];
    //imageView.frame = self.bounds;
    
    //imageView.backgroundColor = [UIColor greenColor];
    
    imageView.frame = _tbc.tabBar.bounds;
    
    
    [_tbc.tabBar addSubview:imageView];
    
}

-(void)createItemWithItemDict:(NSDictionary *)itemDict andItemIdenx:(int)itemIndex  andCount:(int)itemCount
{
    CGRect rect = _tbc.tabBar.frame;
    UIView *itemView = [[UIView alloc] init];
    itemView.frame = CGRectMake(itemIndex*rect.size.width/itemCount, 0, rect.size.width/itemCount, rect.size.height);
    //itemView.backgroundColor = itemIndex%2==0?[UIColor purpleColor]:[UIColor greenColor];
    
    [_tbc.tabBar addSubview:itemView];
    
    
    //按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, itemView.frame.size.width, itemView.frame.size.height*4/5);
    
    [btn setImage:[UIImage imageNamed:[itemDict objectForKey:@"ImageName"]] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:[itemDict objectForKey:@"selectedIage"]] forState:UIControlStateSelected];
    
    btn.tag = itemIndex;
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [itemView addSubview:btn];
    
    //标签
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, btn.frame.size.height, btn.frame.size.width, itemView.frame.size.height*1/5);
    label.textColor = [UIColor colorWithRed:0.37f green:0.37f blue:0.37f alpha:1.00f];
    label.text = [itemDict objectForKey:@"title"];
    label.font =[UIFont systemFontOfSize:9];
    label.textAlignment = NSTextAlignmentCenter;
    [itemView addSubview:label];

    //  设置选中状态下
    if (itemIndex == 0) {
        btn.selected = YES;
        _selectedButton = btn;
        label.textColor = [UIColor colorWithRed:0.16f green:0.72f blue:1.00f alpha:1.00f];
        _selectedLabel = label;
        
        
        
    }
    
    
}
-(void)btnClick:(UIButton *)btn
{
    NSLog(@"111");
    
    _selectedButton.selected = NO;
    btn.selected = YES;
    _selectedButton = btn;
    _tbc.selectedIndex = btn.tag;
    
    _selectedLabel.textColor = [UIColor colorWithRed:0.37f green:0.37f blue:0.37f alpha:1.00f];
    ((UILabel *)[btn.superview.subviews objectAtIndex:1]).textColor = [UIColor colorWithRed:0.16f green:0.72f blue:1.00f alpha:1.00f];
    _selectedLabel = (UILabel *)[btn.superview.subviews objectAtIndex:1];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
