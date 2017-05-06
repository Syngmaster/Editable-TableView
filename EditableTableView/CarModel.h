//
//  CarModel.h
//  EditableTableView
//
//  Created by Syngmaster on 06/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarModel : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *color;
@property (assign, nonatomic) NSInteger yearMake;

+ (CarModel *)generateRandomCar;

@end
