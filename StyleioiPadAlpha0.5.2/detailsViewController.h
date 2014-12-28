//
//  detailsViewController.h
//  StyleioiPadAlpha0.4.1
//
//  Created by admin on 2012-11-19.
//  Copyright (c) 2012 Styleio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol detailsControllerDelegate <NSObject>
@required
- (void)showMap;
- (void)doImageSearch:(UIImage *)image;
- (void)addFavorite:(NSString *)image;
- (void)doDBSearch:(NSString *)image;
@end


@interface detailsViewController : UIViewController {
    
    id <detailsControllerDelegate> delegate;
}
@property (retain)id <detailsControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIButton* mapsButton;
@property (nonatomic, strong) IBOutlet UIImageView *mainImage;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, retain) NSMutableArray *productName;
@property (nonatomic, retain) NSMutableArray *productDetails;
@property (nonatomic, retain) NSMutableArray *productManufacturer;

@property (nonatomic, retain) IBOutlet UILabel *prodName;
@property (nonatomic, retain) IBOutlet UILabel *prodDetails;


-(IBAction)wheretobuy:(id)sender;
-(IBAction)doSearch:(id)sender;
-(IBAction)addToFavorite:(id)sender;
@end
