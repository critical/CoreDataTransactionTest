//
//  ZOFDetailViewController.m
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 27/08/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import "ZOFDetailViewController.h"

#import "ZOFPersonBean.h"
#import "ZOFAddressBean.h"

@interface ZOFDetailViewController ()
- (void)configureView;
@end

@implementation ZOFDetailViewController

#pragma mark - Managing the detail item
@synthesize detailPersonLabel;
@synthesize addressesLabel;

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem && [self.detailItem isKindOfClass:[ZOFPersonBean class]]) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd/MM/yyyy"];
        
        NSString *persDetail = [NSString stringWithFormat:@"%@ %@\n%@", [self.detailItem valueForKey:@"name"], [self.detailItem valueForKey:@"lastName"], [df stringFromDate:[self.detailItem valueForKey:@"birthdate"]]];
        self.detailPersonLabel.text = persDetail;
        
        NSArray *addresses = [self.detailItem valueForKey:@"addresses"];
        NSMutableString *addrLabel = [NSMutableString stringWithString:@""];
        for (ZOFAddressBean *addr in addresses) {
            [addrLabel appendFormat:@"%@\n", [addr description]];
        }
        self.addressesLabel.text = addrLabel;
        self.detailDescriptionLabel.text = [self.detailItem valueForKey:@"lastEvent"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [self setDetailPersonLabel:nil];
    [self setAddressesLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
