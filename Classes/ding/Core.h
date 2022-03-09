#ifndef CORE_H__
#define CORE_H__

/**********************************************
* std
***********************************************/
#ifndef __MFC_FRAME_WORK__
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <wchar.h>
#include <typeinfo>
#include <cmath>
#include <float.h>
#include <assert.h>
#include <time.h>
#include <stdarg.h>
#include <memory>
#endif


/**********************************************
* stl
***********************************************/
#include <limits>
#include <string>
#include <vector>
#include <stack>
#include <list>
#include <set>
#include <map>
#include <unordered_map>
#include <deque>
#include <iostream>
#include <fstream>
#include <iomanip>
#include <sstream>
#include <algorithm>
#include <exception>


/**********************************************
* Macro
***********************************************/
#define TTPNew(T)								TTP_NEW(T)
#define TTPDelete(ptr)							TTP_DELETE(ptr)
#define TTPSafeDelete(ptr)						TTP_SAFE_DELETE(ptr)
#define TTPNewArray(T, count)					TTP_NEW_ARRAY(T, count)
#define TTPDeleteArray(ptr)						TTP_DELETE_ARRAY(ptr)
#define TTPSafeDeleteArray(ptr)					TTP_SAFE_DELETE_ARRAY(ptr)
#define TTPSafeDeleteVector(v)					TTP_SAFE_DELETE_VECTOR(v)
#define TTPSafeDeleteMap(m)						TTP_SAFE_DELETE_MAP(m)

#define TTP_NEW(T)								new T
#define TTP_DELETE(ptr)							delete (ptr)
#define TTP_SAFE_DELETE(ptr)					{ if(ptr) { TTP_DELETE(ptr); (ptr) = nullptr; } }
#define TTP_NEW_ARRAY(T, count)					new (T)[(count)]
#define TTP_DELETE_ARRAY(ptr)					delete [](ptr)
#define TTP_SAFE_DELETE_ARRAY(ptr)				{ if(ptr) { TTP_DELETE_ARRAY(ptr); (ptr) = nullptr; } }
#define TTP_SAFE_DELETE_VECTOR(v)				{ for(size_t i = 0; i < v.size(); i++) TTP_SAFE_DELETE(v[i]); v.clear(); }
#define TTP_SAFE_DELETE_VECTOR_PTR(v)				{ if(v)for(size_t i = 0; i < v->size(); i++) TTP_SAFE_DELETE((*v)[i]); v->clear(); }
#define TTP_SAFE_DELETE_MAP(m)					{ for(auto& it : m) TTP_SAFE_DELETE(it.second); m.clear(); }


/**********************************************
* stl¼òÒ×²Ù×÷
***********************************************/
#define GET_FROM_MAP_BY_ID(m, id, value)		((m.find(id) != m.end()) ? m[id] : value)
#define REMOVE_FROM_MAP_BY_ID(m , id, ret)		{auto it = m.find(id); if (it != m.end()) { m.erase(it); ret = true;}}


/**********************************************
* »ù±¾ÀàÐÍÖØ¶¨Òå
***********************************************/
namespace dan
{
	typedef signed char			i8;			//!< 0 to 127
	typedef short				i16;		//!< ¡§C32,768 to 32,767
	typedef int					i32;		//!< ¡§C2,147,483,648 to 2,147,483,647
	typedef long long			i64;		//!< ¡§C9,223,372,036,854,775,808 to 9,223,372,036,854,775,807
	typedef unsigned char		ui8;
	typedef unsigned short		ui16;
	typedef unsigned int		ui32;
	typedef unsigned long long	ui64;

	typedef unsigned int		uint;
	typedef unsigned long		ulong;
	typedef float				real32;		//!< .4E +/- 38 (7 digits)
	typedef double				real64;		//!< 1.7E +/- 308 (15 digits)
	typedef float				Real;

	typedef unsigned int		Dword;
	typedef int					Bool;
	typedef unsigned char		Byte;
	typedef unsigned char		byte;
	typedef unsigned short		Word;

	//×Ö·ûÀàÐÍ¶¨Òå
	typedef ui8						utf8;
	typedef ui32					utf32;
	typedef std::string				String;
	typedef std::wstring			WString;
	typedef std::stringstream		StringStream;
	typedef String					UTF8String;
	typedef std::basic_string<utf32, std::char_traits<utf32> >	UTF32String;
	typedef std::vector<String>		StringArray;

	//lua int64Ö§³Ö
	typedef std::string lint64;
}


/**********************************************
* ÊýÑ§Ïà¹Ø¶¨Òå
***********************************************/
namespace dan
{
	namespace Math
	{
		const Real PI = (Real)(3.14159265358979323846264338327950288419716939937511);
		const Real PI_2 = Math::PI * 2.0f;
		const Real PI_DIV2 = Math::PI * 0.5f;
		const Real PI_DIV3 = Math::PI / 3.0f;
		const Real PI_DIV4 = Math::PI / 4.0f;
		const Real PI_DIV5 = Math::PI / 5.0f;
		const Real PI_DIV6 = Math::PI / 6.0f;
		const Real PI_DIV8 = Math::PI / 8.0f;
		const Real PI_DIV180 = Math::PI / 180.0f;
		const Real PI_SQR = (Real)(9.86960440108935861883449099987615113531369940724079);
		const Real PI_INV = (Real)(0.31830988618379067153776752674502872406891929148091);
		const Real EPSILON = std::numeric_limits<Real>::epsilon();
		const Real LOWEPSILON = (Real)(1e-04);
		const Real POS_INFINITY = std::numeric_limits<Real>::infinity();
		const Real NEG_INFINITY = -std::numeric_limits<Real>::infinity();
		const Real LN2 = std::log(2.0f);
		const Real LN10 = std::log(10.0f);
		const Real INV_LN2 = 1.0f / LN2;
		const Real INV_LN10 = 1.0f / LN10;
		const Real DEG2RAD = (Real)0.01745329;
		const Real RAD2DEG = (Real)57.29577;
		const Real MIN_REAL = 1.175494351e-38F;
		const Real MAX_REAL = 3.402823466e+38F;

		const float  MIN_FLOAT = 1.175494351e-38F;
		const float  MAX_FLOAT = 3.402823466e+38F;
		const double MIN_DOUBLE = 2.2250738585072014e-308;
		const double MAX_DOUBLE = 1.7976931348623158e+308;

		const Byte	MAX_BYTE = 0xff;
		const short MIN_SHORT = -32768;
		const short MAX_SHORT = 32767;
		const int	MIN_INT = -2147483647 - 1;
		const int	MAX_INT = 2147483647;
		const Word	MAX_WORD = 0xff;
		const Dword MAX_DWORD = 0xffff;
		const i8	MIN_I8 = -128;
		const i8	MAX_I8 = 127;
		const ui8	MAX_UI8 = 0xff;
		const i16	MIN_I16 = -32768;
		const i16	MAX_I16 = 32767;
		const ui16	MAX_UI16 = 0xffff;
		const i32	MIN_I32 = -2147483647 - 1;
		const i32	MAX_I32 = 2147483647;
		const ui32	MAX_UI32 = 0xffffffff;
		const i64	MIN_I64 = -9223372036854775807 - 1;
		const i64	MAX_I64 = 9223372036854775807;
		const ui64	MAX_UI64 = 0xffffffffffffffff;

		inline float absFloat(float value) { return (value < 0.0f ? (-value) : value); };
		inline long long lint64Fmt(std::string int64str) { long long num;  sscanf(int64str.c_str(), "%lld", &num); return num; };

	}
}

#endif // CORE_H__
