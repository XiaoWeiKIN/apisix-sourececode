--
-- Licensed to the Apache Software Foundation (ASF) under one or more
-- contributor license agreements.  See the NOTICE file distributed with
-- this work for additional information regarding copyright ownership.
-- The ASF licenses this file to You under the Apache License, Version 2.0
-- (the "License"); you may not use this file except in compliance with
-- the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

local pkg_cpath_org = package.cpath
local pkg_path_org = package.path
local debug_path = "./?.lua;/opt/zbstudio/lualibs/?/?.lua;/opt/zbstudio/lualibs/?.lua;"
local debug_cpath = "/opt/zbstudio/bin/linux/x64/?.so;/opt/zbstudio/bin/linux/x64/clibs/?.so;"

local apisix_home = "/usr/local/apisix"
local pkg_cpath = apisix_home .. "/deps/lib64/lua/5.1/?.so;"
                  .. apisix_home .. "/deps/lib/lua/5.1/?.so;"
local pkg_path = apisix_home .. "/deps/share/lua/5.1/?.lua;"

-- modify the load path to load our dependencies
package.cpath = debug_cpath..pkg_cpath .. pkg_cpath_org
package.path  = debug_path..pkg_path .. pkg_path_org

require('mobdebug').start("10.168.166.52")

-- pass path to construct the final result
local env = require("apisix.cli.env")(apisix_home, pkg_cpath_org, pkg_path_org)
local ops = require("apisix.cli.ops")
ops.execute(env, arg)
