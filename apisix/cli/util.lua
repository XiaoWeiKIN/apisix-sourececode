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

local require = require
local pcall = pcall
local open = io.open
local popen = io.popen
local exit = os.exit
local stderr = io.stderr
local str_format = string.format
local tonumber = tonumber

local _M = {}


-- Note: The `execute_cmd` return value will have a line break at the end,
-- it is recommended to use the `trim` function to handle the return value.
function _M.execute_cmd(cmd)
    --使用io.popen函数来执行命令（和直接在命令行界面执行命令的结果上一样的，不过使用函数这种方式的结果保存在文件中），在这里执行的就是下面的pwd命令
    local t, err = popen(cmd) --这里返回的t其实是一个文件描述符
    if not t then
        return nil, "failed to execute command: "
                    .. cmd .. ", error info: " .. err
    end

    local data, err = t:read("*all")  --执行read命令读取文件
    t:close()

    if err ~= nil then
        return nil, "failed to read execution result of: "
                    .. cmd .. ", error info: " .. err
    end

    return data --结尾的\n是换行符
end


function _M.trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end


function _M.split(self, sep)
    local sep, fields = sep or ":", {}
    local pattern = str_format("([^%s]+)", sep)
    -- 符合pattern 则回调函数 
    self:gsub(pattern, function(c) fields[#fields + 1] = c end)

    return fields
end


function _M.read_file(file_path)
    local file, err = open(file_path, "rb")
    if not file then
        return false, "failed to open file: " .. file_path .. ", error info:" .. err
    end

    local data, err = file:read("*all")
    if err ~= nil then
        file:close()
        return false, "failed to read file: " .. file_path .. ", error info:" .. err
    end

    file:close()
    return data
end


function _M.die(...)
    stderr:write(...)
    exit(1)
end


function _M.is_32bit_arch()
    local ok, ffi = pcall(require, "ffi")
    if ok then
        -- LuaJIT
        return ffi.abi("32bit")
    end

    local ret = _M.execute_cmd("getconf LONG_BIT")
    local bits = tonumber(ret)
    return bits <= 32
end


function _M.write_file(file_path, data)
    local file, err = open(file_path, "w+")
    if not file then
        return false, "failed to open file: "
                      .. file_path
                      .. ", error info:"
                      .. err
    end

    file:write(data)
    file:close()
    return true
end


function _M.is_file_exist(file_path)
    local file, err = open(file_path)
    if not file then
        return false, "failed to open file: "
                      .. file_path
                      .. ", error info: "
                      .. err
    end

    file:close()
    return true
end


return _M
