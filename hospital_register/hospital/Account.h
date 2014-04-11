//
//  Account.h
//  hospital
//
//  Created by Zhao yang on 3/21/14.
//
//

#import "Entity.h"
#import "ClinicCard.h"

typedef enum {
    GenderMale    =  1,
    GenderFemale  =  2,
} Gender;

@interface Account : Entity

// Basic Info
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *birth;
@property (nonatomic) Gender gender;
@property (nonatomic) float bodyHeight;
@property (nonatomic) float bodyWeight;

// Contact Info
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *mobile;

// Clinic Card
@property (nonatomic, strong) ClinicCard *clinicCard;

+ (instancetype)myAccount;

@end
