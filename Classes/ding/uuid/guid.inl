/*
 * Copyright (c) 2012-2021 Daniele Bartolini et al.
 * License: https://github.com/dbartolini/crown/blob/master/LICENSE
 */

#include "ding/uuid/guid.h"
#include <inttypes.h>

namespace ding
{
inline bool operator==(const Guid& a, const Guid& b)
{
	return a.data1 == b.data1
		&& a.data2 == b.data2
		;
}

inline bool operator<(const Guid& a, const Guid& b)
{
	if (a.data1 != b.data1)
		return a.data1 < b.data1;
	if (a.data2 != b.data2)
		return a.data2 < b.data2;

	return false;
}

template<>
struct hash<Guid>
{
	uint64_t operator()(const Guid& id) const
	{
		return uint64_t(id.data1 ^ id.data2);
	}
};

} // namespace crown
