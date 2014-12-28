//
//  sidebarViewController.h
//  StyleioiPadAlpha0.5.2
//
//  Created by admin on 2012-12-18.
//  Copyright (c) 2012 Styleio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSStackedViewController.h"
#import "UIViewController+PSStackedView.h"
#import "resultsViewController.h"
#import "searchViewController.h"
#import "detailsViewController.h"
#import "favoritesViewController.h"
#import "mapsViewController.h"
#import "settingsViewController.h"
#import "MBProgressHUD.h"

// This category (i.e. class extension) is a workaround to get the
// Image PickerController to appear in landscape mode.

@interface UIImagePickerController(Nonrotating)
- (BOOL)shouldAutorotate;
@end

@implementation UIImagePickerController(Nonrotating)

- (BOOL)shouldAutorotate {
    return NO;
}

@end

@interface sidebarViewController : UIViewController <resultsControllerDelegate,searchControllerDelegate,favoritesControllerDelegate,mapsControllerDelegate,detailsControllerDelegate,settingsControllerDelegate,MBProgressHUDDelegate,UIPopoverControllerDelegate,UIImagePickerControllerDelegate>{
    MBProgressHUD *mbProcess;
}


@property (nonatomic, retain) searchViewController *searchVC;
@property (nonatomic, retain) resultsViewController *resultsVC;
@property (nonatomic, retain) detailsViewController *detailsVC;
@property (nonatomic, retain) favoritesViewController *favoritesVC;
@property (nonatomic, retain) mapsViewController *mapsVC;
@property (nonatomic, retain) sidebarViewController *sideVC;
@property (nonatomic, retain) settingsViewController *settingsVC;

@property (nonatomic, retain) UIPopoverController *popoverSet;
@property (nonatomic, retain) UIPopoverController *albumPopoverController;
@property (nonatomic, retain) UIPopoverController* sourcePopoverController;

@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, strong) IBOutlet UIImageView *sourceImage;

@property (nonatomic, strong) IBOutlet UIButton* settingsButton;
@property (nonatomic, strong) IBOutlet UIButton* favouriteButton;
@property (nonatomic, strong) IBOutlet UIButton* searchButton;
@property (nonatomic, strong) IBOutlet UIButton* resultsButton;

@property (nonatomic, retain) NSString *selectedDB;
@property (nonatomic, retain) NSString *selectedDB1;
@property (nonatomic, retain) NSString *serverhost;
@property (nonatomic, retain) NSString *test1;


@property (nonatomic, retain) NSMutableArray *noOFobjects;
@property (nonatomic, retain) NSMutableArray *labels;
@property (nonatomic, retain) NSMutableArray *jsonobjects;
@property (nonatomic, retain) NSMutableArray *collection;
@property (nonatomic, retain) NSMutableArray *name;
@property (nonatomic, retain) NSMutableArray *manufacturer;
@property (nonatomic, retain) NSMutableArray *articleno;

@property(nonatomic, assign) NSUInteger indexNumber;

-(IBAction)slideChange:(id)sender;
@end
