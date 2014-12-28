//
//  AppDelegate.h
//  StyleioiPadAlpha0.5.2
//
//  Created by admin on 2012-12-18.
//  Copyright (c) 2012 Styleio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sidebarViewController.h"
#import "resultsViewController.h"
#import "searchViewController.h"
#import "PSStackedView.h"
#import "UIViewController+PSStackedView.h"


//@class resultsViewController;
//@class searchViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) PSStackedViewController *stackController;
@property (nonatomic, retain) sidebarViewController *sideVC;

@end
