//
//  ViewController.h
//  StandardExample
//
//  Created by Sebastian Owodziń on 21/02/2015.
//  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.
//

@import UIKit;
@import CoreData;

@interface ViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)refreshButtonTouched:(UIBarButtonItem *)sender;

@end

