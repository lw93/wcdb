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

#ifndef __WCDB_TAG_HPP
#define __WCDB_TAG_HPP

#include <cstdint>
#include <type_traits>

namespace WCDB {

class Tag final {
public:
    static const Tag& invalid();

    Tag(int32_t tag);

    bool operator==(const Tag& other) const;
    bool operator!=(const Tag& other) const;
    operator int32_t() const;
    int32_t value() const;

    bool isValid() const;

private:
    Tag(const std::nullptr_t&);
    int32_t m_value;
};

} // namespace WCDB

namespace std {
template<>
struct is_integral<WCDB::Tag> : public std::true_type {
};
} // namespace std

#endif /* __WCDB_TAG_HPP */
