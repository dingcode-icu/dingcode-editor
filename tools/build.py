# encoding:utf8

from enum import Enum
from genericpath import isdir
import os
import sys
import shutil
import logging


class PublishType(Enum):
    Debug = 1
    Release = 2


class Platform(Enum):
    WINDOW = 1
    MAC = 2


class Builder:

    _publish_type: PublishType

    _plat: Platform

    def __init__(self, ptype: PublishType, plat: Platform) -> None:
        self._publish_type = ptype
        self._plat = plat

    def __get_cmake(self):
        cmake_bin = os.environ.get(
            "CMAKE_HOME", "D:\\dtool\\cmake-3.24.0-rc2-windows-x86_64\\bin\\cmake.exe")
        return cmake_bin

    def __get_projpath(self):
        cur = os.path.dirname(__file__)
        return os.path.dirname(cur)

    def __get_cmakepath(self):
        cur = self.__get_projpath()
        p = "debug" if self._publish_type == PublishType.Debug else "release"
        tool = "visual-studio" if sys.platform == "win32" else "xcode"
        return os.path.join(cur, "cmake-build-{p}-{tool}".format(p=p, tool=tool))

    def __cmake_pre_win(self) -> int:
        cmake_ex = "-DCMAKE_BUILD_TYPE=Release" if self._publish_type == PublishType.Release else ""
        cmd = '''{cmake_bin} -G "Visual Studio 17 2022" -Thost=x64 ^\
            -DCMAKE_JOB_POOLS=pool-linking=1;pool-compilation=2 ^
            -DCMAKE_JOB_POOL_COMPILE:STRING=pool-compilation ^
            -DCMAKE_JOB_POOL_LINK:STRING=pool-linking ^-A Win32 -B {proj_path} {cmake_ex} {path}'''.format(
            cmake_bin=self.__get_cmake(),
            proj_path=self.__get_cmakepath(),
            cmake_ex=cmake_ex,
            path=self.__get_projpath()
        )
        logging.info(cmd)
        return os.system(cmd)

    def __cmake_build_win(self):
        p = "Debug" if self._publish_type == PublishType.Debug else "Release"
        cmd = '''{cmake_bin} --build {path} --target dingcode-editor --config {publish_type}'''.format(
            cmake_bin=self.__get_cmake(),
            publish_type=p,
            path=self.__get_cmakepath()
        )
        logging.info(cmd)
        return os.system(cmd)

    def run(self):
        print("build path ", self.__get_cmakepath())
        p = "Debug" if self._publish_type == PublishType.Debug else "Release"
        # print(sys.platform, "-->>sys.platform ")
        self.__cmake_pre_win()
        self.__cmake_build_win()

        r = os.path.join(self.__get_projpath(), "dist")
        if os.path.isdir(r):
            shutil.rmtree(r)
        shutil.copytree(os.path.join(self.__get_cmakepath(),
                        "bin", "dingcode-editor", p), r)


if __name__ == "__main__":
    b = Builder(PublishType.Release, Platform.WINDOW)
    b.run()
