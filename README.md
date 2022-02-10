# todo-prompt.nvim

🚧 **Work in progress** 🚧

A prompt for todos in neovim written in lua.

https://user-images.githubusercontent.com/1291396/153380753-ac07cbb3-c62a-4d88-b4bc-66ce2c787dda.mov

## Requirements

- Neovim 0.5.0
- [nui.nvim](https://github.com/MunifTanjim/nui.nvim)

## Example usage

This will only print out the task with the parsed date. You can pass it any callback function.
```
:lua require"todo-prompt".AddTask(function(t,d) print(t .. ": " .. os.date("%c", d)) end) 
```
