/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <WCDB/Assertion.hpp>
#import <WCDB/Interface.h>
#import <WCDB/WCTCore+Private.h>

@implementation WCTDatabase (Repair)

static_assert((int) WCTCorruptionReactionCustom == (int) WCDB::Database::CorruptionReaction::Custom, "");
static_assert((int) WCTCorruptionReactionRemove == (int) WCDB::Database::CorruptionReaction::Remove, "");
static_assert((int) WCTCorruptionReactionDeposit == (int) WCDB::Database::CorruptionReaction::Deposit, "");

- (void)setReactionWhenCorrupted:(WCTCorruptionReaction)reaction
{
    _database->setReactionWhenCorrupted((WCDB::Database::CorruptionReaction) reaction);
}

- (WCTCorruptionReaction)reactionWhenCorrupted
{
    return (WCTCorruptionReaction) _database->getReactionWhenCorrupted();
}

- (void)setExtraReactionWhenCorrupted:(WCTCorruptionExtraReactionBlock)onCorrupted
{
    WCDB::Database::CorruptionExtraReaction extraReaction = nullptr;
    if (onCorrupted) {
        extraReaction = [onCorrupted](std::shared_ptr<WCDB::Database> &database) -> bool {
            return onCorrupted([[WCTDatabase alloc] initWithDatabase:database]);
        };
    }
    _database->setExtraReactionWhenCorrupted(extraReaction);
}

- (void)filterBackup:(WCTBackupFilterBlock)tableShouldBeBackedUp
{
    if (tableShouldBeBackedUp) {
        _database->filterBackup([tableShouldBeBackedUp](const std::string &tableName) -> bool {
            return tableShouldBeBackedUp([NSString stringWithCppString:tableName]);
        });
    } else {
        _database->filterBackup(nullptr);
    }
}

- (BOOL)deposit
{
    return _database->deposit();
}

- (void)setAutoBackup:(BOOL)flag
{
    _database->autoBackup(flag);
}

- (BOOL)backup
{
    return _database->backup();
}

- (double)retrieve:(WCTRetrieveProgressUpdateBlock)onProgressUpdate
{
    if (onProgressUpdate) {
        return _database->retrieve([onProgressUpdate](double percentage, double increment) {
            onProgressUpdate(percentage, increment);
        });
    } else {
        return _database->retrieve(nullptr);
    }
}

- (BOOL)removeDeposit
{
    return _database->removeDeposit();
}

- (BOOL)canRetrieve
{
    return _database->canRetrieve();
}

- (BOOL)isCorrupted
{
    return _database->isCorrupted();
}

@end