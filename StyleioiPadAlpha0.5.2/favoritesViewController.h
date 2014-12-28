//
//  favoritesViewController.h
//  StyleioiPadAlpha0.4.1
//
//  Created by admin on 2012-11-19.
//  Copyright (c) 2012 Styleio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol favoritesControllerDelegate <NSObject>
@required
- (void)favoritesSelected:(NSString *)favorite;
@end


@interface favoritesViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>
{
    id <favoritesControllerDelegate> delegate;
    NSDictionary *favouritesdic;
    IBOutlet UITableView *tableView;
}

@property (retain)id <favoritesControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *favourites;
@property (nonatomic, retain) NSMutableArray *favouritesimages;
@property (nonatomic, retain) NSMutableArray *favouritesdetails;
@end
