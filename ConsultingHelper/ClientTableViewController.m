//
//  ClientTableViewController.m
//  ConsultingHelper
//
//  Created by Vision Retail on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClientTableViewController.h"

@interface ClientTableViewController (){
    NSMutableArray *companies;
}

@end

@implementation ClientTableViewController

@synthesize  delegate;
@synthesize managedObjectContext;
@synthesize clientTable;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        companies = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.managedObjectContext == nil) {
        self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    [self fetchCoreData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setClientTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [companies count];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate setClientDelegate:[companies objectAtIndex:indexPath.row]];
    [self dismissModalViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    return 100;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"clientCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Company *thisClient = [companies objectAtIndex:indexPath.row];
    UIImageView *clientPic = (UIImageView*)[cell viewWithTag:1];
    UILabel *clientName = (UILabel*)[cell viewWithTag:2];
    UILabel *companyName = (UILabel*)[cell viewWithTag:3];
    if(thisClient.localImage){
        UIImage *profilePic = [UIImage imageWithData:thisClient.localImage];
        clientPic.image = profilePic;
    }
    clientPic.image = [UIImage imageNamed:@"shop_Man.png"];
    clientName.text = thisClient.clientName;
    companyName.text = thisClient.companyName;
    // Configure the cell...
    
    return cell;
}








-(void)fetchCoreData{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    companies = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:request error:&error]];
    
}



@end

