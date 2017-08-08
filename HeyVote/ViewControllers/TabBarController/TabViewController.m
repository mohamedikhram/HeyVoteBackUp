//
//  TabViewController.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import "TabViewController.h"
#import "ChildViewController.h"

@interface TabViewController () <MSSPageViewControllerDataSource, MSSPageViewControllerDelegate>

@end

@implementation TabViewController

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
       _style = [TabControllerStyle styleWithName:@"Distributed Images" tabStyle:MSSTabStyleImage sizingStyle:MSSTabSizingStyleDistributed numberOfTabs:5];
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController.viewControllers.firstObject == self) { // only show styles option if initial screen
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Styles"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showStylesScreen:)];
    }
    
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tabBarView setTransitionStyle:self.style.transitionStyle];
    self.tabBarView.tabStyle = self.style.tabStyle;
    self.tabBarView.sizingStyle = self.style.sizingStyle;
}

#pragma mark - Interaction

- (void)showStylesScreen:(id)sender {
    [self performSegueWithIdentifier:@"showStylesSegue" sender:self];
}

#pragma mark - Page View Controller

- (NSArray *)viewControllersForPageViewController:(MSSPageViewController *)pageViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NSMutableArray *viewControllers = [NSMutableArray new];
    
    for (NSInteger i = 0; i < self.style.numberOfTabs; i++) {
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"viewController1"];
        [viewControllers addObject:viewController];
    }
    return viewControllers;
}

- (void)tabBarView:(MSSTabBarView *)tabBarView populateTab:(MSSTabBarCollectionViewCell *)tab atIndex:(NSInteger)index {
    NSString *imageName = [NSString stringWithFormat:@"tab%i.png", (int)(index + 1)];
    NSString *pageName = [NSString stringWithFormat:@"Page %i", (int)(index + 1)];
    
    tab.image = [UIImage imageNamed:imageName];
    tab.title = pageName;
}

@end
