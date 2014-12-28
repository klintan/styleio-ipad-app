//
//  settingsViewController.h
//  StyleioiPadAlpha0.4.1
//
//  Created by admin on 2012-11-20.
//  Copyright (c) 2012 Styleio. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol settingsControllerDelegate <NSObject>
@required
- (void)selectedDatabase:(NSString *)db;
@end

@interface settingsViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>{
    NSInteger *selectedRow;

    id <settingsControllerDelegate> delegate;
}
@property (retain)id <settingsControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *database;

@end

