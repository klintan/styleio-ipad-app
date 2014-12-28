//
//  detailsViewController.m
//  StyleioiPadAlpha0.4.1
//
//  Created by admin on 2012-11-19.
//  Copyright (c) 2012 Styleio. All rights reserved.
//

#import "detailsViewController.h"

@interface detailsViewController ()

@end

@implementation detailsViewController
@synthesize delegate;
@synthesize mapsButton,imageName,mainImage, productDetails, productName, productManufacturer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [mainImage.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [mainImage.layer setBorderWidth: 0.8];
    
    
	// Do any additional setup after loading the view
    productManufacturer = [[NSMutableArray alloc] init];
    productDetails = [[NSMutableArray alloc] init];
    productName = [[NSMutableArray alloc] init];
    
    
    [productName addObject:@" Mandara 04"];
    [productName addObject:@"Tapet nr 7653"];
    [productName addObject:@"Zaria 09"];
    [productName addObject:@"Trifid 02"];
    [productName addObject:@"Tapet nr 7653"];
    [productName addObject:@"Grove Garden 03"];
   
    [productDetails addObject:@"Design: Anthony Little & Peter Osborne (1968). A grand stylised pineapple damask named after the famous Italian port."];
    [productDetails addObject:@"Detta är en originaltapet från 1970-talet och den omfattas därför av begränsade garantier. Läs mer under Köpvillkor."];
    [productDetails addObject:@"Silhouettes of a forest set against cool metallic shades of silver, gilver, gold and mica. MANDARA, a Hindu girls' name meaning 'mythical tree', comes in shades of calm neutrals, rich chocolates and teals, and soft powder pinks and aquas. Blanka träd mot matt bakgrund."];
    [productDetails addObject:@"Detta är en originaltapet från 1970-talet och den omfattas därför av begränsade garantier. Läs mer under Köpvillkor."];
    [productDetails addObject:@"Design: Anthony Little & Peter Osborne (1968). A grand stylised pineapple damask named after the famous Italian port."];
    [productDetails addObject:@"Detta är en originaltapet från 1970-talet och den omfattas därför av begränsade garantier. Läs mer under Köpvillkor."];
    
    [productManufacturer addObject:@"Sanderson"];
    [productManufacturer addObject:@"Osborne & Little"];
    [productManufacturer addObject:@"Sanderson"];
    [productManufacturer addObject:@"Osborne & Little"];
    [productManufacturer addObject:@"Osborne & Little"];
    [productManufacturer addObject:@"Sanderson"];

    
    NSURL *imgurl=[NSURL URLWithString:imageName];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imgurl];
    mainImage.image = [UIImage imageWithData: imageData];
}

-(IBAction)wheretobuy:(id)sender{
    NSLog(@"Where to buy pushed");
    [[self delegate] showMap];
}

-(IBAction)doSearch:(id)sender{
     NSLog(@"Use as source pushed");
    //[[self delegate] doImageSearch:mainImage.image];
    [[self delegate] doDBSearch:imageName];

}

-(IBAction)addToFavorite:(id)sender{
    NSLog(@"Add to favorite pushed");
    [[self delegate] addFavorite:imageName];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
