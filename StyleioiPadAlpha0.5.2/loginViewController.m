//
//  LoginViewController.m
//  StyleioAlpha
//
//  Created by admin on 2012-04-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "loginViewController.h"
//#import "ResultsViewController.h"

@interface loginViewController ()

@end

NSInteger *firsttime;
@implementation loginViewController

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
	// Do any additional setup after loading the view.
    
    //Initialize the array.
    listOfItems = [[NSMutableArray alloc] init];
    
    //Add items
    [listOfItems addObject:@"Email"];
    [listOfItems addObject:@"Password"];
    
    
}

-(void)endEditing:(id)send {
	[send resignFirstResponder];
}



-(IBAction)login:(id)sender {
    
    
    //Declaring variables
    NSData *receivedData;
	NSURLResponse *response;
	NSError *errors;
	NSString *myemail = email.text;
	NSString *mypassword = password.text;
	
    
    //Debugging, write email and password variable to console
	NSLog(@"%@",email);
    NSLog(@"%@",password);
	
    
    [[NSUserDefaults standardUserDefaults]setObject:email forKey:@"email"];
	
	//HTTP post string
	NSString *post = [NSString stringWithFormat:@"&email=%@&password=%@",myemail, mypassword];
	NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
    //Create HTTP request
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"http://imaginate.se/styleio2/php/checklogin.php"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
    receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&errors];
	
	NSString *tempstring = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
	if(tempstring == nil);
    {
        NSLog(@"tempstring nil");
      tempstring = @"test";
    }
	if ([tempstring isEqualToString:@"Wrong Email or Password"]) {
		
		NSString *msg = @"Fel användarnamn eller lösenord";
		UIAlertView *wrongpass = [[UIAlertView alloc] initWithTitle:@"Fel" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[wrongpass show];
        
		NSLog(@"fel lösenord eller email");
	}
	else {
 
        NSLog(@"Success");
        firsttime = 0;
        [self performSegueWithIdentifier:@"login" sender:self];
		
	}
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [listOfItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setBackgroundView:nil];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];  
    }
    
    // Set up the cell...
    NSString *cellValue = [listOfItems objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    
    //create editable textfield for email
    if (indexPath.row == 0) {
		CGRect frame = CGRectMake (110, 10, 170, 30);
		UITextField *myemail = [[UITextField alloc] initWithFrame:frame];
        
        email = myemail;
		//[email setDelegate:self];
		[email setAutocapitalizationType:UITextAutocapitalizationTypeNone];
		[email setReturnKeyType:UIReturnKeyNext];
		[email setAutocorrectionType:UITextAutocorrectionTypeNo];
		[email becomeFirstResponder];
		[cell.contentView addSubview: email];
	}
    
    //create editable textfield for password
	if (indexPath.row == 1) {
		CGRect frame = CGRectMake (110, 10, 170, 30);
		UITextField *pass = [[UITextField alloc] initWithFrame:frame];
		
		password = pass;
		[password setSecureTextEntry:YES];
		[password setAutocorrectionType:UITextAutocorrectionTypeNo];
		[password setReturnKeyType:UIReturnKeyDone];
		//[password setDelegate:self];
		
		[password addTarget:self
					 action:@selector(login:)
		   forControlEvents:UIControlEventEditingDidEndOnExit];
		[cell.contentView addSubview: password];
		
	}
    
    
    
    return cell;
    
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
