//
//  DataBAseManager.h
//  UniversalSharing
//
//  Created by Roman on 8/17/15.
//  Copyright (c) 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataBaseManager : NSObject {
    sqlite3 *_database;
}

+ (DataBaseManager*)dataBaseManager;
-(void)insertIntoTable:(id) object;
@end
