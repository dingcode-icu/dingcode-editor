# endcoding:utf8
from urllib.parse import urljoin
import requests
import os
import sys
import lupa
import logging
import json


REMOTE_HOST = "http://static.bbclient.icu:8083"


class Api:
    @staticmethod
    def chk_ret(ret):
        if (ret.status_code != 200):
            logging.error(
                "req the {} to get dnode list failed!".format(REMOTE_HOST))
            sys.exit(1)
        d = json.loads(ret.content)
        print(d, "-->>contente")

        if (d["code"] != 0):
            logging.error(
                "req the {} to get dnode raise error!".format(d["msg"]))
            sys.exit(1)


class DNode:
    name = ""
    descrip = ""
    graph_type = ""
    suppose_type = ""
    code_id = 0
    input = ""
    output = ""

    def __init__(self, dic) -> None:
        print(dic, '--》》dic', dic["graph_type"])
        self.descrip = dic["descrip"]
        self.graph_type = dic["graph_type"]
        self.suppose_type = dic["suppose_type"]
        self.input = dic["input"]
        self.output = dic["output"]

    def __str__(self) -> str:
        return json.dumps(self.info(), sort_keys=True, indent=4)

    def info(self):
        return json.dumps(\
            {\
                "name": self.name,
                "suppose_type": self.suppose_type,
                "descrip": self.descrip,
                "graph_type": self.graph_type
            }\
        )

    def async_to_services():
        requests.post(REMOTE_HOST, "/api/dingcode/add", json.dump())


class Run:
    _luaenv = None
    _iter_path = ""
    _remote_dic = {}

    def __init__(self, tarp):
        self._luaenv = lupa.LuaRuntime()
        self._iter_path = tarp
        print(tarp,  "-->>tarp")
        print(urljoin(REMOTE_HOST, "/api/dingcode/dnode"))
        # ret = requests.get(urljoin(REMOTE_HOST, "/api/dingcode/dnode"))
        # Api.chk_ret(ret)

    def chk_remote(self):
        pass

    def iter_lua_files(self):
        dnode_fl = []
        for root, _, files in os.walk(self._iter_path):
            for f in files:
                if f.endswith(".lua"):
                    dnode_fl.append(os.path.join(root, f))
        for src in dnode_fl:
            with open(src, 'r') as lsrc:
                c = self._luaenv.execute("\n".join(lsrc.readlines()))
                if not c:
                    print("[error]{src} execut return empty!".format(src=src))
                else:
                    for i in c:
                        if int(i) > 0:
                            d = DNode(c[i])

                        
                            
                             
                    # d = DNode(c)
                    # print(d)


if __name__ == "__main__":
    PATH = "../res/engine/cocos"
    input_arg0 = os.path.join(os.getcwd(), PATH)
    r = Run(input_arg0)
    r.iter_lua_files()
