/*
 * Copyright (c) 2012-2021 Daniele Bartolini et al.
 * License: https://github.com/dbartolini/crown/blob/master/LICENSE
 */


#include "ding/guid/guid.h"
#include <inttypes.h>
#include <stdio.h>  // sscanf
#include <assert.h>

#define CE_UNUSED(x) do { (void)(x); } while (0)
#if defined(_WIN32) || defined(_WIN64)
	#include <objbase.h>
#else
    #define PLATFORM_POSIX 1
    #include <fcntl.h>
	#include <unistd.h>
	#include <errno.h>
#endif

namespace ding
{
namespace guid_globals
{
#if PLATFORM_POSIX
	static int _fd = -1;
#endif

	void init()
	{
#if PLATFORM_POSIX
		_fd = ::open("/dev/urandom", O_RDONLY);
		assert(_fd != -1);
#endif // PLATFORM_POSIX
	}

	void shutdown()
	{
#if PLATFORM_POSIX
		::close(_fd);
		_fd = -1;
#endif // PLATFORM_POSIX
	}

} // namespace guid_globals

namespace guid
{
	Guid new_guid()
	{
		Guid guid;

#if defined(_WIN32) || defined(_WIN64)
		HRESULT hr = CoCreateGuid((GUID*)&guid);
		assert(hr == S_OK);
		CE_UNUSED(hr);
#else
		assert(guid_globals::_fd != -1);
		ssize_t rb = read(guid_globals::_fd, &guid, sizeof(guid));
		assert(rb == sizeof(guid));
		CE_UNUSED(rb);
		guid.data1 = (guid.data1 & 0xffffffffffff4fffu) | 0x4000u;
		guid.data2 = (guid.data2 & 0x3fffffffffffffffu) | 0x8000000000000000u;
#endif
        return guid;
	}

	Guid parse(const char* str)
	{
		Guid guid;
		try_parse(guid, str);
		return guid;
	}

	bool try_parse(Guid& guid, const char* str)
	{
		assert(NULL != str);
		int32_t a, b, c, d, e, f;
		int num = sscanf(str, "%8x-%4x-%4x-%4x-%4x%8x", &a, &b, &c, &d, &e, &f);
		guid.data1  = uint64_t (a) << 32;
		guid.data1 |= uint64_t (b) << 16;
		guid.data1 |= uint64_t (c) <<  0;
		guid.data2  = uint64_t (d) << 48;
		guid.data2 |= uint64_t (e) << 32;
		guid.data2 |= uint64_t (f) <<  0;
		return num == 6;
	}

	const char* to_string(char* buf, uint32_t len, const Guid& guid)
	{
		snprintf(buf, len, "%.8x-%.4x-%.4x-%.4x-%.4x%.8x"
			, (uint32_t)((guid.data1 & 0xffffffff00000000u) >> 32)
			, (uint16_t)((guid.data1 & 0x00000000ffff0000u) >> 16)
			, (uint16_t)((guid.data1 & 0x000000000000ffffu) >>  0)
			, (uint16_t)((guid.data2 & 0xffff000000000000u) >> 48)
			, (uint16_t)((guid.data2 & 0x0000ffff00000000u) >> 32)
			, (uint32_t)((guid.data2 & 0x00000000ffffffffu) >>  0)
			);
		return buf;
	}

} // namespace guid

} // namespace ding
