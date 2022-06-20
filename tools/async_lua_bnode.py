# endcoding:utf8
from typing import Dict, List
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
    def chk_ret(ret:requests.Response):
        print(ret)
        if (ret.status_code != 200):
            logging.error(
                "req the {} to {} api failed!".format(ret.url, ret.request.method))
            logging.error(ret)
            sys.exit(1)
        d = json.loads(ret.content)
        print(d, "-->>contente")

        if (d["code"] != 0):
            logging.error(
                "req the {} to api raise error!code={}, msg={}".format(ret.url, d["code"], d["msg"]))
            # sys.exit(1)


class DNode:
    name = ""
    descrip = ""
    graph_type = ""
    suppose_type = ""
    code_id = 0
    input = ""
    output = ""

    def __init__(self, dic:Dict) -> None:
        self.name = dic["name"]
        self.descrip = dic["desc"]
        self.graph_type = dic.get("type", "unknown")
        self.suppose_type = dic.get("supposeType", "unknown")
        self.input = dic.get("input", '''{}''') 
        self.output = dic.get("output", '''{}''') 

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

    def data(self):
        return {
            "name": self.name,
            "suppose_type": self.suppose_type,
            "descrip": self.descrip,
            "graph_type": self.graph_type
        }

    def async_to_services(self):
        ret = requests.post(urljoin(REMOTE_HOST, "/api/dingcode/add"), data=self.info(), headers={
            "Content-Type":"application/json"
        })
        Api.chk_ret(ret)
        logging.info("success!")
        # sys.exit(1)


class Run:
    _luaenv = None
    _iter_path = ""
    _remote_dic = {}

    def __init__(self, tarp):
        self._iter_path = tarp
        ret = requests.get(urljoin(REMOTE_HOST, "/api/dingcode/dnode"))
        Api.chk_ret(ret)
        self._remote_dic = json.loads(ret.content)

    def chk_remote(self):
        pass

    def iter_lua_files(self):
        self._luaenv = lupa.LuaRuntime()
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

                        
    def upload_by_graphtype(self, dic):
        for name in dic.keys():
            n = DNode(dic[name])
            n.async_to_services()

    def upload_json(self, jsf):
        with open(jsf, "r") as jf:
            c = jf.read()
            dic = json.loads(str(c))
            for c in dic.keys():
                g_dic = dic[c]
                print(g_dic, type(g_dic))
                if (type(dic[c]) == list):
                    logging.warning("json child named {} is not dict type , so ignore!".format(c))
                else:
                    self.upload_by_graphtype(g_dic)

if __name__ == "__main__":
    PATH = "../res/engine/cocos"
    JS_FILE ="/Users/dwb/Downloads/all_node11.json"
    JS_FILE ="all_node.json"
    input_arg0 = os.path.join(os.getcwd(), PATH)
    r = Run(input_arg0)
    # r.iter_lua_files()
    r.upload_json(JS_FILE)