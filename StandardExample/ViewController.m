//
//  ViewController.m
//  StandardExample
//
//  Created by Sebastian Owodziń on 21/02/2015.
//  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"
#import "ExampleEntity.h"

@interface ViewController ()

@property (readonly, strong, nonatomic) NSFetchedResultsController * _fetchedResultsController;

@end

@implementation ViewController

@synthesize _fetchedResultsController = __fetchedResultsController;

- (IBAction)refreshButtonTouched:(UIBarButtonItem *)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    for ( NSUInteger idx = 0; idx < 1000; idx++ ) {
        ExampleEntity *entity = [NSEntityDescription insertNewObjectForEntityForName:@"ExampleEntity" inManagedObjectContext:appDelegate.managedObjectContext];
        
        entity.name = [NSString stringWithFormat:@"entity_%lu", idx];
    }
    
    [appDelegate saveContext];
}

- (NSFetchedResultsController *)_fetchedResultsController {
    if ( nil == __fetchedResultsController ) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ExampleEntity"];
        fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
        
        __fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        __fetchedResultsController.delegate = self;
    }
    
    return __fetchedResultsController;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    [self._fetchedResultsController performFetch:&error];
    if ( nil != error ) {
        [[[UIAlertView alloc] initWithTitle:@"ERROR" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if ( NSFetchedResultsChangeInsert == type ) {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if ( NSFetchedResultsChangeUpdate == type ) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if ( NSFetchedResultsChangeDelete == type ) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if ( NSFetchedResultsChangeMove == type ) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self._fetchedResultsController.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self._fetchedResultsController.sections[section];
    
    return sectionInfo.name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self._fetchedResultsController.sections[section];
    
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExampleCell" forIndexPath:indexPath];
    
    ExampleEntity *entity = (ExampleEntity *)[self._fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = entity.name;
    
    return cell;
}

@end
