//
//  ViewController.m
//  UI_maoboli
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 FJX. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UISearchBarDelegate>

@property (nonatomic, retain)UIVisualEffectView *effectView;
@property (nonatomic, retain)UISearchBar *searchBar;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    self.effectView.alpha = 0;
    self.effectView.frame = self.view.bounds;
    [self.imageView addSubview:self.effectView];
    
    self.imageView.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panBlurAction:)];
    pan.minimumNumberOfTouches = 1;
    [self.imageView addGestureRecognizer:pan];
    
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -60, self.view.bounds.size.width, 28)];
    
    searchBar.barStyle = UIBarStyleDefault;
    searchBar.translucent = YES;
    searchBar.placeholder = @"搜索";
    
//    searchBar.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
//    searchBar.barTintColor = [UIColor colorWithWhite:1.0 alpha:0];
//    searchBar.tintColor = [UIColor colorWithWhite:1.0 alpha:0];
    
    searchBar.hidden = NO;

    self.searchBar = searchBar;
    searchBar.delegate = self;
    
    [self.imageView addSubview:searchBar];
    
    //删除searchBar原有的背景
    for (UIView *view in self.searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0)
        {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
    UITextField *searchField;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0)
        searchField =[searchBar.subviews objectAtIndex:1];
    else
        searchField = [((UIView *)[searchBar.subviews objectAtIndex:0]).subviews lastObject];
    //获取searchField 并改变它的背景颜色
//    searchField.backgroundColor = [UIColor lightGrayColor];
    searchField.backgroundColor = [UIColor clearColor];
    searchField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    searchField.layer.borderWidth = 0.38;
    searchField.layer.cornerRadius = 15;
}

-(void)panBlurAction:(UIPanGestureRecognizer *)p
{
    CGPoint pt = [p translationInView:p.view];
    
    NSLog(@"pt.y = %lf", pt.y);
    self.effectView.alpha += pt.y * 0.003;
    NSLog(@"%lf", self.effectView.alpha);
    if (self.effectView.alpha >= 1)
    {
//        self.searchBar.hidden = NO;
        self.effectView.alpha = 1;
    }
    else if(self.effectView.alpha < 0)
    {
        self.effectView.alpha = 0;
//        self.searchBar.hidden = YES;
    }
    [self moveSearchBarToPoint:pt.y * 0.1];
    
}

-(void)moveSearchBarToPoint:(CGFloat)valueYOffset
{
    CGPoint p = self.searchBar.frame.origin;
    CGPoint currP = CGPointMake(p.x, p.y + valueYOffset);

    if (currP.y > 40) {
        currP.y = 40;
    }
    
    if (currP.y < -60) {
        currP.y = -60;
    }
    
    if (currP.y <= -18 && valueYOffset < 0) {
        currP.y = -60;
    }
    
    NSLog(@"currP = %lf", currP.y);
    
    self.searchBar.frame = CGRectMake(currP.x, currP.y, self.view.bounds.size.width, 28);
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    UIButton *cancelButton;
    UIView *topView = self.searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
        }
    }
    if (cancelButton) {
        //Set the new title of the cancel button
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.tintColor = [UIColor grayColor];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
