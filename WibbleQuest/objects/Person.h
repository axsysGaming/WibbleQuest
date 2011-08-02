//
//  Person.h
//  WibbleQuest
//
//  Created by orta therox on 15/07/2011.
//  Copyright 2011 http://ortatherox.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : WibbleObject {
  BOOL _seenPlayer;
}

-(void)respondToSentenceArray:(NSArray*)sentence;
-(void)playerEntersSameRoom;
-(void)onFirstSeetingPlayer{};
@end
