//
//  MyViewController.m
//  EditableTableView
//
//  Created by Syngmaster on 06/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "MyViewController.h"
#import "Group.h"
#import "CarModel.h"

@interface MyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *carArray;
@property (weak, nonatomic) UILabel *footerLabel;

@end

@implementation MyViewController

- (void) loadView {
    [super loadView];
    
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.carArray = [NSMutableArray array];

    self.navigationItem.title = @"Car Models";

    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEdit:)];
    
    UIBarButtonItem *addSectionBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddSection:)];
    
    self.navigationItem.rightBarButtonItem = editBarButton;
    self.navigationItem.leftBarButtonItem = addSectionBarButton;
    
}

- (void)delayInteractions {
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    });
    
}

#pragma mark - Action Bar Buttons

- (void)actionEdit:(UIBarButtonItem *) sender {
    
    BOOL isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (self.tableView.editing) {
        
        item = UIBarButtonSystemItemDone;
        
    }
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:@selector(actionEdit:)];
    
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
    
}

- (void)actionAddSection:(UIBarButtonItem *) sender {
    
    Group *group = [[Group alloc] init];
    group.name = [NSString stringWithFormat:@"Group %i",(int)[self.carArray count] + 1];
    group.carArray = @[[CarModel generateRandomCar],[CarModel generateRandomCar],[CarModel generateRandomCar],[CarModel generateRandomCar],[CarModel generateRandomCar]];
    
    NSInteger newIndex = 0;
    [self.carArray insertObject:group atIndex:newIndex];
    
    [self.tableView beginUpdates];
    
    NSIndexSet *newIndexSet = [NSIndexSet indexSetWithIndex:newIndex];
    
    UITableViewRowAnimation anim = UITableViewRowAnimationTop;
    
    if ([self.carArray count] > 1) {
        
        anim = [self.carArray count] % 2 ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight;
        
    }
    
    [self.tableView insertSections:newIndexSet withRowAnimation:anim];
    
    [self.tableView endUpdates];
    
    [self delayInteractions];

}


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    Group *group = [self.carArray objectAtIndex:section];
    
    return [group.carArray count] + 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.carArray count];
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    Group *group = [self.carArray objectAtIndex:section];
    
    return [NSString stringWithFormat:@"%@", group.name];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        
        static NSString *addIdentifier = @"AddCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addIdentifier];
        }
        
        cell.textLabel.text = @"Add a car";
        cell.textLabel.textColor = [UIColor redColor];
        
        return cell;
        
    } else {
        
        static NSString *identifier = @"CarCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        
        
        Group *group = [self.carArray objectAtIndex:indexPath.section];
        CarModel *car = [group.carArray objectAtIndex:indexPath.row - 1];
        
        if (car.yearMake > 2000) {
            
            cell.detailTextLabel.textColor = [UIColor greenColor];
            
        } else {
            
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
        
        cell.textLabel.text = car.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",(int)car.yearMake];
        
        return cell;
    }

}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (indexPath.row == 0) ? NO:YES;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    Group *sourceGroup = [self.carArray objectAtIndex:sourceIndexPath.section];
    CarModel *car = [sourceGroup.carArray objectAtIndex:sourceIndexPath.row - 1];
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceGroup.carArray];
    
    if (sourceIndexPath.section == destinationIndexPath.section) {
        
        [tempArray exchangeObjectAtIndex:sourceIndexPath.row - 1 withObjectAtIndex:destinationIndexPath.row - 1];
        
        sourceGroup.carArray = tempArray;
        
    } else {
        
        [tempArray removeObject:car];
        sourceGroup.carArray = tempArray;
        
        Group *destinationGroup = [self.carArray objectAtIndex:destinationIndexPath.section];
        tempArray = [NSMutableArray arrayWithArray:destinationGroup.carArray];
        [tempArray insertObject:car atIndex:destinationIndexPath.row - 1];
        destinationGroup.carArray = tempArray;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Group *group = [self.carArray objectAtIndex:indexPath.section];
        CarModel *car = [group.carArray objectAtIndex:indexPath.row - 1];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:group.carArray];
        [tempArray removeObject:car];
        group.carArray = tempArray;
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];

    }
    
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Delete Car";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (indexPath.row == 0)?UITableViewCellEditingStyleNone:UITableViewCellEditingStyleDelete;
    
}

//first row in each section cannot be shifted by moving other rows

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    if (proposedDestinationIndexPath.row == 0) {
        return sourceIndexPath;
    } else {
        return proposedDestinationIndexPath;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        Group *group = [self.carArray objectAtIndex:indexPath.section];
        
        NSMutableArray *tempArray = nil;
        
        if (group.carArray) {
            
            tempArray = [NSMutableArray arrayWithArray:group.carArray];
            
        } else {
            
            tempArray = [NSMutableArray array];

        }
        
        NSInteger newIndex = 0;
        [tempArray insertObject:[CarModel generateRandomCar] atIndex:0];
        group.carArray = tempArray;
        
        [self.tableView beginUpdates];
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:newIndex + 1 inSection:indexPath.section];
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self.tableView endUpdates];
        
        [self delayInteractions];

    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > 0) {
        
        cell.frame = CGRectMake(0 - CGRectGetWidth(cell.frame)/2, CGRectGetMinY(cell.frame),
                                CGRectGetWidth(cell.frame), CGRectGetHeight(cell.frame));
        
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             cell.frame = CGRectMake(0, CGRectGetMinY(cell.frame),
                                                     CGRectGetWidth(cell.frame),
                                                     CGRectGetHeight(cell.frame));
                             
                             
                         } completion:nil];
    }

}


@end
