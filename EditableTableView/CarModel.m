//
//  CarModel.m
//  EditableTableView
//
//  Created by Syngmaster on 06/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//




#import "CarModel.h"

@implementation CarModel

static NSString* carModelArray[] = {
    
    @"Acura",
    @"Alfa Romeo",
    @"Alpine",
    @"Amuse",
    @"Aston Martin",
    @"Audi",
    @"Bentley",
    @"BMW",
    @"Bugatti",
    @"Cadillac",
    @"Chevrolet",
    @"Chrysler",
    @"Citroën",
    @"Daihatsu",
    @"Dodge",
    @"Ferrari",
    @"Fiat",
    @"Ford",
    @"Honda",
    @"Hyundai",
    @"Infiniti",
    @"Isuzu",
    @"Jaguar",
    @"Lamborghini",
    @"Lexus",
    @"Mazda",
    @"Mercedes-Benz",
    @"Mitsubishi"
};

static NSString* carColor[] = {
    
    @"White",
    @"Black",
    @"Yellow",
    @"Red",
    @"Orange",
    @"Pink",
    @"Green",
    @"Brown",
    @"Gray",
    @"Gold",
    @"Silver",
    @"Blue"
};

static int modelCount = 28;
static int colorCount = 12;



+ (CarModel *)generateRandomCar {
    
    CarModel *newCar = [[CarModel alloc] init];
    
    newCar.name = carModelArray[arc4random() % modelCount];
    newCar.color = carColor[arc4random() % colorCount];
    newCar.yearMake = arc4random() % 25 + 1990;
    
    return newCar;
    
}

@end
