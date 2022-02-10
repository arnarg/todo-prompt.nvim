# todo-prompt.nvim

🚧 **Work in progress** 🚧

A prompt for todos in neovim written in lua.

https://user-images.githubusercontent.com/1291396/153485158-a4249560-a9f0-4534-a310-d8e109c248d7.mov

## Requirements

- Neovim 0.5.0
- [nui.nvim](https://github.com/MunifTanjim/nui.nvim)

## Installation

With [packer.nvim](https://github.com/wbthomason/packer.nvim):
```lua
use {
	'arnarg/todo-prompt.nvim',
	requires = {'MunifTanjim/nui.nvim'},
}
```

## Quickstart

Add the `setup()` function to your init file.

For `init.lua`:
```lua
require('todo-prompt').setup({
	callback = function(task, date)
		print(task, os.date("%d/%m/%y %H:%M", date))
	end
})
```

For `init.vim`:
```vim
lua <<EOF
require('todo-prompt').setup({
	callback = function(task, date)
		print(task, os.date("%d/%m/%y %H:%M", date))
	end
})
EOF
```

## Configuration

Here are all the available options to pass to `setup()`. Available values for `width` and `position` are documented in [nui.nvim](https://github.com/MunifTanjim/nui.nvim/tree/4998347f02fde115ad0c023b90be9c5654834635/lua/nui/popup#position).
```lua
{
	prompt = "> ",                  -- Prompt printed in the start of the line.
	width = "75%",                  -- Width of the prompt window.
	position = "50%",               -- Position of the prompt window.
	callback = function(task, date) -- Callback function that will be called after
		print(task, date)	-- confirming the prompt.
	end,
}
```

## Usage

After calling setup you can open a prompt with `:ToDoPrompt`. This will call whatever callback is specified in the setup options.

If you want to use another callback you can run `:lua require('todo-prompt').add_task(function(t, d) print(t, d) end)`.

## Date parsing

The date parser is more or less a re-implementation of [when](https://github.com/olebedev/when/) in lua without support for past dates (I don't think there's a need for scheduling a task in the past) and more hacky (lua doesn't have full regex support built-in).

Example dates it can parse:

- Take out trash **in two weeks** (also `in 2 weeks`)
- Bring in car for oil change **in half a year**
- Call mom **on Monday**
- Take spot to vet **tomorrow**
- Go to doctor **at 4pm**
- Buy gift for wife **on twenty first of may**
- Clean bathroom **21/4/2021**

Parsers can also be combined (when one is for date and the other time):

- Pick up medication **on Tuesday afternoon** (this Tuesday at 3pm)
- Check up on my best friend **in a month at 17:00** (same day in a month at 5pm)
