//
//  searchViewController.h
//  StyleioiPadAlpha0.4.1
//
//  Created by admin on 2012-11-19.
//  Copyright (c) 2012 Styleio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@protocol searchControllerDelegate <NSObject>
@required
- (void)doImageSearch:(UIImage *)image;
- (void)doTextSearch:(NSString *)text;
- (void)takePicture;
- (void)getAlbumImage;
@end

@interface searchViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UIPopoverControllerDelegate, UISearchBarDelegate,MBProgressHUDDelegate>{
    NSMutableArray *searchOptions;
    NSMutableArray *searchOptionsImage;
    UITableViewCell *cell;
    id <searchControllerDelegate> delegate;

    
}
@property (retain)id <searchControllerDelegate> delegate;
@property (nonatomic, retain) UIPopoverController* popoverController;
//@property (nonatomic, retain)  UIImagePickerController *imagePicker;
@property (nonatomic, retain) UISearchBar *searchField;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, strong)MBProgressHUD *mbProcess;
@end
