# todo-prompt.nvim

🚧 **Work in progress** 🚧

A prompt for todos in neovim written in lua.

https://user-images.githubusercontent.com/1291396/153485158-a4249560-a9f0-4534-a310-d8e109c248d7.mov

## Requirements

- Neovim 0.5.0
- [nui.nvim](https://github.com/MunifTanjim/nui.nvim)

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

## Example usage

This will only print out the task with the parsed date. You can pass it any callback function.
```
:lua require"todo-prompt".AddTask(function(t,d) print(t .. ": " .. os.date("%c", d)) end) 
```
