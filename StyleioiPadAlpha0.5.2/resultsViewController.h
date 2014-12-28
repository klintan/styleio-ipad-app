//
//  resultsViewController.h
//  StyleioiPadAlpha0.4.1
//
//  Created by admin on 2012-11-19.
//  Copyright (c) 2012 Styleio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol resultsControllerDelegate <NSObject>
@required
- (void)initialLoad;
- (void)tapDetails:(NSInteger *)tag;
- (void)goBack;
@end

@interface resultsViewController : UIViewController<UIScrollViewDelegate>{
    id <resultsControllerDelegate> delegate;
}
@property (retain)id <resultsControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *imgarray;
@property (nonatomic, strong) NSMutableArray  *colarray;
@property (nonatomic, strong) NSMutableArray  *patarray;
@property (nonatomic, strong) NSMutableArray  *collection;
@property (nonatomic, strong) NSMutableArray  *name;
@property (nonatomic, strong) NSMutableArray *articleno;
@property (nonatomic, strong) NSMutableArray  *manufacturer;

@property (nonatomic, strong) IBOutlet UIScrollView *resultsScroll;


@end
