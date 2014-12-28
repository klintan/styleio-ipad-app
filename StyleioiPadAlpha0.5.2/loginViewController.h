//
//  LoginViewController.h
//  StyleioAlpha
//
//  Created by admin on 2012-04-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *listOfItems;
    UITextField *email;
    UITextField *password;
    IBOutlet UITableView *tableView;
    
}

-(void)endEditing:(id)send;
-(IBAction)login:(id)sender;

@end
