//
//  BBTwitterMessage.h
//  NotificationsWall
//
//  Created by Błażej Biesiada on 4/18/12.
//  Copyright (c) 2012 Błażej Biesiada. All rights reserved.
//

#import "BBMessage.h"

@interface BBTwitterMessage : BBMessage

- (id)initWithJSONDict:(NSDictionary *)msgDict;

@end
