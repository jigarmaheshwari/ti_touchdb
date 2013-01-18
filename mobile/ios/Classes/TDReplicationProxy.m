//
//  TDReplicationProxy.m
//  titouchdb
//
//  Created by Paul Mietz Egli on 12/10/12.
//
//

#import "TDReplicationProxy.h"
#import "TiProxy+Errors.h"

@interface TDReplicationProxy ()
@property (nonatomic, strong) TDReplication * replication;
@end

@implementation TDReplicationProxy

- (id)initWithTDReplication:(TDReplication *)replication {
    if (self = [super init]) {
        self.replication = replication;
    }
    return self;
}

#pragma mark Replication Configuration

- (id)remoteURL {
    return [self.replication.remoteURL absoluteString];
}

- (id)pull {
    return NUMBOOL(self.replication.pull);
}

- (id)persistent {
    return NUMBOOL(self.replication.persistent);
}

- (void)setPersistent:(id)value {
    self.replication.persistent = [value boolValue];
}

- (id)create_target {
    return NUMBOOL(self.replication.create_target);
}

- (void)setCreate_target:(id)value {
    self.replication.create_target = [value boolValue];
}

- (id)continuous {
    return NUMBOOL(self.replication.continuous);
}

- (void)setContinuous:(id)value {
    self.replication.continuous = [value boolValue];
}

- (id)filter {
    return self.replication.filter;
}

- (void)setFilter:(id)value {
    ENSURE_STRING_OR_NIL(value)
    self.replication.filter = value;
}

- (id)query_params {
    return self.replication.query_params;
}

- (void)setQuery_params:(id)value {
    ENSURE_DICT(value)
    self.replication.query_params = value;
}

- (id)doc_ids {
    return self.replication.doc_ids;
}

- (void)setDoc_ids:(id)value {
    ENSURE_ARRAY(value)
    self.replication.doc_ids = value;
}

- (id)headers {
    return self.replication.headers;
}

- (void)setHeaders:(id)value {
    ENSURE_DICT(value)
    self.replication.headers = value;
}

#pragma mark Replication Status

- (id)start:(id)args {
    [self.replication start];
}

- (id)stop:(id)args {
    [self.replication stop];
}

- (id)running {
    return NUMBOOL(self.replication.running);
}

- (id)completed {
    return NUMINT(self.replication.completed);
}

- (id)total {
    return NUMINT(self.replication.total);
}

- (id)error {
    return [self errorDict:self.replication.error];
}

- (id)mode {
    return NUMINT(self.replication.mode);
}

#pragma mark Notifications

#define kReplicationChangedEventName @"change"

- (void)replicationChanged:(NSNotification *)notification {
    [self fireEvent:kReplicationChangedEventName withObject:notification.userInfo];
}

- (void)_listenerAdded:(NSString*)type count:(int)count {
    if ([kReplicationChangedEventName isEqualToString:type] && count == 0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replicationChanged:) name:kTDReplicationChangeNotification object:nil];
    }
}

- (void)_listenerRemoved:(NSString*)type count:(int)count {
    if ([kReplicationChangedEventName isEqualToString:type] && count == 0) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kTDReplicationChangeNotification object:nil];
    }
}


@end