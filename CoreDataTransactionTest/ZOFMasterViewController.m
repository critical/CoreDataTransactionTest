//
//  ZOFMasterViewController.m
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 27/08/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import "ZOFMasterViewController.h"

#import "ZOFDetailViewController.h"
#import "ZOFPersonBean.h"
#import "ZOFAddressBean.h"
#import "ZOFAddressTypeBean.h"
#import "ZOFTestViewController.h"

@interface ZOFMasterViewController () {
    NSArray *persons;
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation ZOFMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _serviceDb = [ZOFServiceDb sharedInstance];
    
 	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *testBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(loadTestViewController:)];
    self.navigationItem.leftBarButtonItems = @[self.editButtonItem, testBtn];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    persons = [_serviceDb fetchBeanName:@"ZOFPersonBean" inContext:nil withPredicate:nil];
    //persons = [_serviceDb fetchBeanName:@"ZOFPersonBean" withPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"lastEvent", @"Videochat su Facebook"]];
    
    //persons = [_serviceDb fetchBeanName:@"ZOFAddressBean" predicateWithSubstitutionVariables:[NSDictionary dictionaryWithObject:@"2" forKey:@"addrType"]];
    //persons = [_serviceDb fetchBeanName:@"ZOFAddressTypeBean" withPredicate:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)insertNewObject:(id)sender
{
    ZOFAddressTypeBean *type = [_serviceDb fetchBeanName:@"ZOFAddressTypeBean" inContext:nil  withPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"type", @"Residenza"]];
    
    
    ZOFAddressBean *addr = [[ZOFAddressBean alloc] init];
    addr.artifId = ZOFGetUUID();
    addr.street = [NSString stringWithFormat:@"street%d", rand()%10];
    addr.zip = [NSString stringWithFormat:@"zip%d", rand()%10];
    addr.country = @"Italia";
    addr.addrType = type;

    ZOFPersonBean *p = [[ZOFPersonBean alloc] init];
    p.artifId = ZOFGetUUID();
    p.name = [NSString stringWithFormat:@"first%d", rand()%10];
    p.lastName = [NSString stringWithFormat:@"last%d", rand()%10];
    p.birthdate = [NSDate date];
    p.addresses = @[ addr ];
    
    NSError *err;
    [_serviceDb saveBean:p error:err];
    [[self tableView] reloadData];
}

- (void)loadTestViewController:(id)sender
{
    [self performSegueWithIdentifier:@"testControllerSegue" sender:self];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [persons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSError *error = nil;
        [_serviceDb deleteBean:[persons objectAtIndex:indexPath.row] error:error];
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ZOFPersonBean *object = [persons objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    } else if ([[segue identifier] isEqualToString:@"testControllerSegue"]) {
        [[segue destinationViewController] setServiceDb:_serviceDb];
    }
}


#pragma mark - Override

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ZOFPersonBean *p = [persons objectAtIndex:indexPath.row];
    cell.textLabel.text = p.lastName;
    cell.detailTextLabel.text = p.name;
    /*
    ZOFAddressBean *p = [persons objectAtIndex:indexPath.row];
    cell.textLabel.text = p.artifId;
    cell.detailTextLabel.text = p.addrType.type;
    */
}

NSString *ZOFGetUUID()
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
    CFRelease(uuidStringRef);
    return uuid;
}

@end
